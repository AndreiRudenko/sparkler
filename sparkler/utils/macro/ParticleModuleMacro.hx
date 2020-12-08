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
						var pe = p.expr;
						var tPath:Array<String> = [];
						while(pe != null) {
							switch (pe) {
								case EField(e, f):
									pe = e.expr;
									tPath.insert(0, f);
								case EConst(CIdent(s)):
									tPath.insert(0, s);
									pe = null;
								default: break;
							}
						}

						var name = tPath.join('.');
						var at = Context.getType(name);
						opt.addModules.push(at);
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
