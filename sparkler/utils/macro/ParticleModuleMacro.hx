package sparkler.utils.macro;

#if (macro || display)

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.ComplexTypeTools;
import haxe.macro.TypeTools;
import sparkler.utils.macro.MacroUtils;

class ParticleModuleMacro {

	static public var moduleOptions:Map<String, ParticleModuleMacroOptions> = new Map();

	static public function build():Array<Field> {
		var cp:String = Context.getLocalModule();
		var t = Context.getLocalType();

		var opt:ParticleModuleMacroOptions = {
			name: cp,
			type: t,
			particleTypeName: null,
			isInjectType: false,
			priority: 0,
			group: null,
			imports: [],
			fields: [],
			addModules: []
		}

		var c = TypeTools.getClass(t);
		switch (c.superClass.params[0]) {
			case TInst(t, p):
				var pack = t.toString().split('.');
				var pName = pack[pack.length-1];
				opt.particleTypeName = pack[pack.length-1];
			default:
		}

		var metas = c.meta.get();
		for (m in metas) {
			switch (m.name) {
				case 'inject':
					opt.isInjectType = true;
				case 'priority':
					var e = m.params[0].expr;
					switch (e) {
						case EConst(c):
							switch (c) {
								case CInt(i):
									opt.priority = Std.parseInt(i);
								default:
							}
						default: throw('@priority meta must be a Int');
					}
				case 'group':
					var e = m.params[0].expr;
					switch (e) {
						case EConst(c):
							switch (c) {
								case CString(s):
									opt.group = s;
								default:
							}
						default: throw('@group meta must be a String');
					}
				case 'addModules':
					for (p in m.params) {
						switch (p.expr) {
							case EField(e, f):
								var at = Context.getType(f);
								opt.addModules.push(at);
							default: throw('@addModule meta must be a Type');
						}
					}
				default:
			}
		}

		var fields = Context.getBuildFields();

		opt.imports = Context.getLocalImports();

		for (f in fields) {
			if(!MacroUtils.hasFieldMeta(f, 'virtual')) opt.fields.push(f);
		}

		moduleOptions.set(cp, opt);

		return fields;
	}

}

typedef ParticleModuleMacroOptions = {
	name:String,
	type:Type,
	particleTypeName:String,
	isInjectType:Bool,
	priority:Float,
	group:String,
	imports:Array<ImportExpr>,
	fields:Array<Field>,
	addModules:Array<Type>
}

#end
