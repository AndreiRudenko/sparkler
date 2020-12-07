package sparkler.utils.macro;

#if (macro || display)

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import haxe.macro.ComplexTypeTools;

import sparkler.utils.macro.MacroUtils;
import sparkler.utils.macro.ParticleModuleMacro;

class ParticleEmitterMacro {

	public static inline var particleModulePath:String = 'sparkler.ParticleModule';
	public static inline var particleInjectModulePath:String = 'sparkler.ParticleInjectModule';

	static public var typeName:String = "ParticleEmitter";
	static public var emitterIds:Map<String, String> = new Map();

	static var idx:Int = 0;
	static var emitterTypeNames:Array<String> = ['ParticleEmitterBase'];

	static var iModules:Array<InjectModule> = [
		{name:'sparkler.modules.render.ClaySpriteRendererModule', inject:sparkler.modules.render.ClaySpriteRendererModule.inject},
		{name:'sparkler.modules.render.KhaSpriteRendererModule', inject:sparkler.modules.render.KhaSpriteRendererModule.inject}
	];

	static var filterMeta:Map<String, Array<String>> = new Map();

	static public function build() {
		return switch (Context.getLocalType()) {
			case TInst(_.get() => {name: typeName}, types):
				buildEmitter(types);
			default:
				throw false;
		}
	}

	static function buildEmitter(types:Array<Type>) {
		var eName = getEmitterName(types);

		if(emitterTypeNames.indexOf(eName) == -1) {
			var pos = Context.currentPos();

			var groupNames:Array<String> = [];

			filterMeta = new Map();

			var fields:Array<Field> = [];
			var particleTypes:Array<Type> = [];
			var optFields:Array<Field> = [];

			var defTypes:Array<Type> = [];
			var injectTypes:Array<Type> = [];

			// separate default and inject modules
			for (t in types) {
				var c = TypeTools.getClass(t);
				if(c.superClass != null) {
					var gName = getModuleGroup(c);
					if(gName != null) {
						if(groupNames.indexOf(gName) != -1) {
							throw('Cant have more than one module "${c.name}" in group "${gName}"');
						}
						groupNames.push(gName);
					}
					var cname = c.superClass.t.toString();
					if(cname == particleModulePath) {
						defTypes.push(t);
					} else if(cname == particleInjectModulePath){
						injectTypes.push(t);
					}
				}
			}

			addDefaultModules(groupNames, defTypes, injectTypes);

			// sort modules
			defTypes.sort(function(a:Type, b:Type) {
				var aidx = getModulePriority(TypeTools.getClass(a));
				var bidx = getModulePriority(TypeTools.getClass(b));
				return Std.int(aidx - bidx);
			});

			injectTypes.sort(function(a:Type, b:Type) {
				var aidx = getModulePriority(TypeTools.getClass(a));
				var bidx = getModulePriority(TypeTools.getClass(b));
				return Std.int(aidx - bidx);
			});

			types = defTypes;

			// get particle types from all modules
			for (t in types) {
				var c = TypeTools.getClass(t);
				var param = c.superClass.params[0];
				switch (param) {
					case TInst(t, p):
						var pack = t.toString().split('.');
						var pName = pack[pack.length-1];
						var pTypes = ParticleMacro.particleTypes.get(pName);
						if(pTypes != null) {
							for (pt in pTypes) {
								if(!MacroUtils.hasType(particleTypes, pt)) {
									particleTypes.push(pt);
								}
							}
						}
					default:
				}
			}

			// get particle types names
			var particleFieldNames:Array<String> = [];

			for (pt in particleTypes) {
				var info = MacroUtils.getPathInfo(pt);
				var compName = MacroUtils.toCamelCase(info.name);
				particleFieldNames.push(compName);
			}

			// build particle type
			var pType = ParticleMacro.buildParticle(particleTypes);
			var pInfo = MacroUtils.getPathInfo(pType);
			var pTInfo = {pack: pInfo.pack, name: pInfo.module, sub: pInfo.name};
			var pCType = Context.toComplexType(pType);

			// push sortFunc option
			var sortFuncOpt = MacroUtils.buildVar(
				'sortFunc', 
				[Access.APublic], 
				macro: (a:$pCType, b:$pCType)->Int, 
				null, 
				[{name: ':optional', pos: pos}]
			);
			optFields.push(sortFuncOpt);

			// setup emitter exprs
			var newExprs:Array<Expr> = [macro super(options)];

			newExprs.push(macro {
				if(options.sortFunc != null) sortFunc = options.sortFunc;
			});

			var emitExprs:Array<Expr> = [];
			var onStartExprs:Array<Expr> = [];
			var onStopExprs:Array<Expr> = [];

			var onUpdateExprs:Array<Expr> = [];
			var onStepStartExprs:Array<Expr> = [];
			var onStepExprs:Array<Expr> = [];
			var onStepEndExprs:Array<Expr> = [];
			var onParticleUpdateExprs:Array<Expr> = [];
			var onParticleSpawnExprs:Array<Expr> = [];
			var onParticleUnspawnExprs:Array<Expr> = [];

			var emitterImports:Array<ImportExpr> = [];

			var peopt:ParticleEmitterBuildOptions = {
				groupNames: groupNames,
				particleType: pType,
				particleFieldNames: particleFieldNames,
				fields: fields,
				optFields: optFields,

				newExprs: newExprs,
				emitExprs: emitExprs,
				onStartExprs: onStartExprs,
				onStopExprs: onStopExprs,
				onUpdateExprs: onUpdateExprs,
				onStepStartExprs: onStepStartExprs,
				onStepExprs: onStepExprs,
				onStepEndExprs: onStepEndExprs,
				onParticleUpdateExprs: onParticleUpdateExprs,
				onParticleSpawnExprs: onParticleSpawnExprs,
				onParticleUnspawnExprs: onParticleUnspawnExprs,

				emitterImports: emitterImports
			};

			// apply default modules
			injectDefaultModules(peopt, types);

			// apply inject modules
			for (it in injectTypes) {
				var n = MacroUtils.getTypePath(it);
				for (i in 0...iModules.length) {
					if(n == iModules[i].name) {
						iModules[i].inject(peopt);
					}
				}
			}

			// add default exprs
			injectDefaultExprs(peopt);

			// create options type
			var optPTInfo = {pack: ['sparkler'], name: 'ParticleEmitter', sub: 'ParticleEmitterOptions'};
			var optName = '${eName}Options';

			var opDef:TypeDefinition = {
				fields: [],
				kind: TDAlias(TExtend([optPTInfo], optFields)),
				pack: ['sparkler'],
				name: optName,
				pos: pos
			};
			
			Context.defineType(opDef);

			var opType = Context.getType('sparkler.$optName');
			var opCType = Context.toComplexType(opType);

			// create emitter fields
			newExprs.push(macro {
				var p;
				for (i in 0...cacheSize) {
					p = new $pTInfo(i);
					p.index = i;
					particles[i] = p;
				}
			}); 

			if(newExprs.length > 0) {
				var newField = MacroUtils.buildFunction(
					'new', 
					[APublic], 
					[{name: 'options', type: opCType}],
					macro: Void,
					newExprs
				);
				fields.push(newField);
			}

			if(onStartExprs.length > 0) {
				var onStart = MacroUtils.buildFunction(
					'onStart', 
					[AOverride], 
					[],
					macro: Void,
					onStartExprs
				);
				fields.push(onStart);
			}

			if(emitExprs.length > 0) {
				var emit = MacroUtils.buildFunction(
					'emit', 
					[AOverride], 
					[],
					macro: Void,
					emitExprs
				);
				fields.push(emit);
			}

			if(onStopExprs.length > 0) {
				var onStop = MacroUtils.buildFunction(
					'onStop', 
					[AOverride], 
					[],
					macro: Void,
					onStopExprs
				);
				fields.push(onStop);
			}

			if(onStepExprs.length > 0) {
				var onStepField = MacroUtils.buildFunction(
					'onStep', 
					[AOverride], 
					[{name: 'elapsed', type: macro:Float}],
					macro: Void,
					onStepExprs
				);
				fields.push(onStepField);
			}

			if(onUpdateExprs.length > 0) {
				var onUpdateField = MacroUtils.buildFunction(
					'onUpdate', 
					[AOverride], 
					[{name: 'elapsed', type: macro:Float}],
					macro: Void,
					onUpdateExprs
				);
				fields.push(onUpdateField);
			}

			if(onStepStartExprs.length > 0) {
				var onStepStartField = MacroUtils.buildFunction(
					'onStepStart', 
					[AOverride], 
					[{name: 'elapsed', type: macro:Float}],
					macro: Void,
					onStepStartExprs
				);
				fields.push(onStepStartField);
			}

			if(onStepEndExprs.length > 0) {
				var onStepEndField = MacroUtils.buildFunction(
					'onStepEnd', 
					[AOverride], 
					[{name: 'elapsed', type: macro:Float}],
					macro: Void,
					onStepEndExprs
				);
				fields.push(onStepEndField);
			}

			if(onParticleUpdateExprs.length > 0) {
				var onParticleUpdateField = MacroUtils.buildFunction(
					'onParticleUpdate', 
					[AOverride], 
					[{name: 'p', type: pCType}, {name: 'elapsed', type: macro:Float}],
					macro: Void,
					onParticleUpdateExprs
				);
				fields.push(onParticleUpdateField);
			}

			if(onParticleSpawnExprs.length > 0) {
				var onParticleSpawnField = MacroUtils.buildFunction(
					'onParticleSpawn', 
					[AOverride], 
					[{name: 'p', type: pCType}],
					macro: Void,
					onParticleSpawnExprs
				);
				fields.push(onParticleSpawnField);
			}

			if(onParticleUnspawnExprs.length > 0) {
				var onParticleUnspawnField = MacroUtils.buildFunction(
					'onParticleUnspawn', 
					[AOverride], 
					[{name: 'p', type: pCType}],
					macro: Void,
					onParticleUnspawnExprs
				);
				fields.push(onParticleUnspawnField);
			}

			// filter and check imports
			emitterImports = filterDuplicateImport(emitterImports);
			checkDuplicateClassImport(emitterImports);

			// define emitter type
			var eTDef:TypeDefinition = {
				pack: ['sparkler'],
				name: eName,
				pos: pos,
				meta: [],
				kind: TDClass({
					pack: ["sparkler"],
					name: "ParticleEmitter",
					sub: "ParticleEmitterBase",
					params : [TPType(TPath(pTInfo))]
				}),
				fields: fields
			}

			emitterTypeNames.push(eName);

			Context.defineModule('sparkler.${eName}', [eTDef], emitterImports);
		}

		return Context.getType('sparkler.${eName}');
	}

	static function filterDuplicateImport(importExprs:Array<ImportExpr>):Array<ImportExpr> {
		var importsNames:Array<String> = [];
		var importsClean:Array<ImportExpr> = [];

		// clear imports
		var iPath:String;
		for (i in importExprs) {
			iPath = getImportPathString(i);
			if(importsNames.indexOf(iPath) == -1) {
				importsNames.push(iPath);
				importsClean.push(i);
			}
		}
		return importsClean;
	}

	static function getImportPathString(iExpr:ImportExpr):String {
		var iPath = '';
		for (j in 0...iExpr.path.length) {
			iPath += iExpr.path[j].name;
			if(j < iExpr.path.length-1) {
				iPath += '.';
			}
		}
		return iPath;
	}

	static function checkDuplicateClassImport(importExprs:Array<ImportExpr>) {
		var importsClassNames:Array<String> = [];
		var importPaths:Array<String> = [];

		// clear imports
		var iName:String;
		var iPath:String;
		for (i in importExprs) {
			iPath = getImportPathString(i);
			iName = i.path[i.path.length-1].name;
			var idx = importsClassNames.indexOf(iName);
			if(idx == -1) {
				importPaths.push(iPath);
				importsClassNames.push(iName);
			} else {
				var otherIPath = importPaths[idx];
				trace('Warning: import class with different path but same name: "${otherIPath}", and "${iPath}"');
			}
		}
	}

	static function addDefaultModules(groupNames:Array<String>, defTypes:Array<Type>, injectTypes:Array<Type>) {
		if(groupNames.indexOf('emit') == -1) {
			defTypes.push(Context.getType('sparkler.modules.emit.EmitRateModule'));
		}

		if(groupNames.indexOf('lifetime') == -1) {
			defTypes.push(Context.getType('sparkler.modules.life.LifetimeModule'));
		}

		if(groupNames.indexOf('emitterLife') == -1) {
			defTypes.push(Context.getType('sparkler.modules.life.EmitterLifetimeModule'));
		}
	}

	static function injectDefaultExprs(options:ParticleEmitterBuildOptions) {
		var groupNames = options.groupNames;
		var onParticleSpawnExprs = options.onParticleSpawnExprs;
		var emitExprs = options.emitExprs;

		if(groupNames.indexOf('particlesPerEmit') == -1) {
			emitExprs.insert(0, macro {
				spawn();
			}); 
		}

		if(groupNames.indexOf('spawn') == -1) {
			onParticleSpawnExprs.insert(0, macro {
				setParticlePos(p, 0, 0);
			}); 
		}
	}


	static function injectDefaultModules(options:ParticleEmitterBuildOptions, types:Array<Type>) {
		var fields = options.fields;
		var optFields = options.optFields;

		var newExprs = options.newExprs;
		var emitExprs = options.emitExprs;
		var onUpdateExprs = options.onUpdateExprs;
		var onStepStartExprs = options.onStepStartExprs;
		var onStepExprs = options.onStepExprs;
		var onStepEndExprs = options.onStepEndExprs;
		var onParticleSpawnExprs = options.onParticleSpawnExprs;
		var onParticleUnspawnExprs = options.onParticleUnspawnExprs;
		var onParticleUpdateExprs = options.onParticleUpdateExprs;
		var onStartExprs = options.onStartExprs;
		var onStopExprs = options.onStopExprs;
		var emitterImports = options.emitterImports;

		// inject function exprs

		for (t in types) {
			var moduleName = MacroUtils.getTypePath(t);
			var moduleFields = ParticleModuleMacro.moduleFields.get(moduleName);
			var moduleImports = ParticleModuleMacro.moduleImports.get(moduleName);
			for (i in moduleImports) emitterImports.push(i);
			
			for (mf in moduleFields) {
				var filterTag:String = null;
				for (m in mf.meta) {
					switch (m.name) {
						case 'filter':
							filterTag = getMetaString(m);
							if(filterTag == null) throw('filter must have tag: "@filter("tag")"');
						default:
					}
				}

				switch (mf.kind) {
					case FVar(t, e):
						pushFilteredField(fields, filterTag, mf);
					case FProp(g, s):
						pushFilteredField(fields, filterTag, mf);
					case FFun(f):
						switch (mf.name) {
							case 'new': 
								switch (mf.kind) {
									case FFun(ff):
										if(ff.args.length != 1 || ff.args[0].name != 'options') {
											throw('number arguments of constructor must be one, and name options');
										}
										for (arg in ff.args) {
											switch (arg.type) {
												case TAnonymous(aFields):
													for (af in aFields) {
														optFields.push(af);
													}
												default: throw('options type must be Anonymous structure');
											}
										}
									default:
								}
								newExprs.push(f.expr);

							case 'emit': pushFilteredExpr(emitExprs, filterTag, 'emit', f.expr, false);
							case 'onStepStart': pushFilteredExpr(onStepStartExprs, filterTag, 'onStepStart', f.expr, false);
							case 'onUpdate': pushFilteredExpr(onUpdateExprs, filterTag, 'onUpdate', f.expr, false);
							case 'onStep': pushFilteredExpr(onStepExprs, filterTag, 'onStep', f.expr, false);
							case 'onStepEnd': pushFilteredExpr(onStepEndExprs, filterTag, 'onStepEnd', f.expr, false);
							case 'onParticleSpawn': pushFilteredExpr(onParticleSpawnExprs, filterTag, 'onParticleSpawn', f.expr, false);
							case 'onParticleUnspawn': pushFilteredExpr(onParticleUnspawnExprs, filterTag, 'onParticleUnspawn', f.expr, false);
							case 'onParticleUpdate': pushFilteredExpr(onParticleUpdateExprs, filterTag, 'onParticleUpdate', f.expr, false);
							case 'onStart': pushFilteredExpr(onStartExprs, filterTag, 'onStart', f.expr, false);
							case 'onStop': pushFilteredExpr(onStopExprs, filterTag, 'onStop', f.expr, false);

							case 'onPreStepStart': pushFilteredExpr(onStepStartExprs, filterTag, 'onStepStart', f.expr, true);
							case 'onPreStep': pushFilteredExpr(onStepExprs, filterTag, 'onStep', f.expr, true);
							case 'onPreStepEnd': pushFilteredExpr(onStepEndExprs, filterTag, 'onStepEnd', f.expr, true);
							case 'onPreParticleSpawn': pushFilteredExpr(onParticleSpawnExprs, filterTag, 'onParticleSpawn', f.expr, true);
							case 'onPreParticleUnspawn': pushFilteredExpr(onParticleUnspawnExprs, filterTag, 'onParticleUnspawn', f.expr, true);
							case 'onPreParticleUpdate': pushFilteredExpr(onParticleUpdateExprs, filterTag, 'onParticleUpdate', f.expr, true);
							case 'onPreStart': pushFilteredExpr(onStartExprs, filterTag, 'onStart', f.expr, true);
							case 'onPreStop': pushFilteredExpr(onStopExprs, filterTag, 'onStop', f.expr, true);

							case 'onPostStepStart' | 'onPostStep' | 'onPostStepEnd' | 
							'onPostParticleSpawn' | 'onPostParticleUnspawn' | 
							'onPostParticleUpdate' | 'onPostStart' | 'onPostStop':

							default: pushFilteredField(fields, filterTag, mf);
						}
					default:
				}
			}
		}
		for (t in types) {
			var moduleName = MacroUtils.getTypePath(t);
			var moduleFields = ParticleModuleMacro.moduleFields.get(moduleName);
			
			for (mf in moduleFields) {
				var filterTag:String = null;
				for (m in mf.meta) {
					switch (m.name) {
						case 'filter':
							filterTag = getMetaString(m);
							if(filterTag == null) throw('filter must have tag: "@filter("tag")"');
						default:
					}
				}

				switch (mf.kind) {
					case FFun(f):
						switch (mf.name) {
							case 'onPreStepStart': pushFilteredExpr(onStepStartExprs, filterTag, 'onStepStart', f.expr, false);
							case 'onPostStep': pushFilteredExpr(onStepExprs, filterTag, 'onStep', f.expr, false);
							case 'onPostStepEnd': pushFilteredExpr(onStepEndExprs, filterTag, 'onStepEnd', f.expr, false);
							case 'onPostParticleSpawn': pushFilteredExpr(onParticleSpawnExprs, filterTag, 'onParticleSpawn', f.expr, false);
							case 'onPostParticleUnspawn': pushFilteredExpr(onParticleUnspawnExprs, filterTag, 'onParticleUnspawn', f.expr, false);
							case 'onPostParticleUpdate': pushFilteredExpr(onParticleUpdateExprs, filterTag, 'onParticleUpdate', f.expr, false);
							case 'onPostStart': pushFilteredExpr(onStartExprs, filterTag, 'onStart', f.expr, false);
							case 'onPostStop': pushFilteredExpr(onStopExprs, filterTag, 'onStop', f.expr, false);
							default:
						}
					default:
				}
			}
		}
	}

	static function pushFilteredExpr(exprs:Array<Expr>, tag:String, fName:String, e:Expr, first:Bool = false) {
		var insert = true;

		if(tag != null) {
			var fm = filterMeta.get(fName);
			insert = false;

			if(fm == null) {
				fm = [];
				filterMeta.set(fName, fm);
			}

			if(fm.indexOf(tag) == -1) {
				fm.push(tag);
				insert = true;
			}
		}

		if(insert) {
			if(first) {
				exprs.insert(0, e);
			} else {
				exprs.push(e);
			}
		}
	}

	static function pushFilteredField(fields:Array<Field>, tag:String, f:Field) {
		if(tag != null) {
			var fm = filterMeta.get(f.name);

			if(fm == null) {
				fm = [];
				filterMeta.set(f.name, fm);
			}

			if(fm.indexOf(tag) == -1) {
				fm.push(tag);
				fields.push(f);
			}
		} else {
			fields.push(f);
		}
	}

	static function getEmitterName(types:Array<Type>):String {
		var typesString = MacroUtils.getStringFromTypes(types);

		var name = '${typeName}_${typesString}';

		var uuid:String = emitterIds.get(name);

		if(uuid == null) {
			uuid = '${typeName}_${idx++}';
			emitterIds.set(name, uuid);
		}
		
		return uuid;
	}

	static function getModulePriority(c:ClassType):Float {
		var metas = c.meta.get();
		for (m in metas) {
			if(m.name == 'priority') {
				var e = m.params[0].expr;
				switch (e) {
					case EConst(c):
						switch (c) {
							case CInt(i):
								return Std.parseInt(i);
							case CFloat(f):
								return Std.parseFloat(f);
							default:
						}
					default:
				}
			}
		}
		return 0;
	}

	static function getModuleGroup(c:ClassType):String {
		var metas = c.meta.get();
		for (m in metas) {
			if(m.name == 'group') {
				var e = m.params[0].expr;
				switch (e) {
					case EConst(c):
						switch (c) {
							case CString(s):
								return s;
							default:
						}
					default:
				}
			}
		}
		return null;
	}

	static function getFieldMetaTag(field:Field, meta:String):String {
		var meta = MacroUtils.getFieldMeta(field, meta);
		if(meta != null) {
			for (e in meta.params) {
				switch (e.expr) {
					case EConst(c):
						switch (c) {
							case CString(s):
								return s;
							default:
						}
					default:
				}
			}
		}

		return null;
	}

	static function getMetaString(meta:MetadataEntry):String {
		switch (meta.params[0].expr) {
			case EConst(c):
				switch (c) {
					case CString(s):
						return s;
					default:
				}
			default:
		}
		return null;
	}
}

typedef InjectModule = {
	name:String, 
	inject:(options:ParticleEmitterBuildOptions)->Void
}

typedef ParticleEmitterBuildOptions = {
	groupNames:Array<String>,
	particleType:Type,
	particleFieldNames:Array<String>,
	fields:Array<Field>,
	optFields:Array<Field>,

	newExprs:Array<Expr>,
	emitExprs:Array<Expr>,
	onStartExprs:Array<Expr>,
	onStopExprs:Array<Expr>,
	onUpdateExprs:Array<Expr>,
	onStepStartExprs:Array<Expr>,
	onStepExprs:Array<Expr>,
	onStepEndExprs:Array<Expr>,
	onParticleUpdateExprs:Array<Expr>,
	onParticleSpawnExprs:Array<Expr>,
	onParticleUnspawnExprs:Array<Expr>,

	emitterImports:Array<ImportExpr>,

}

#end