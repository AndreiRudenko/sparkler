package sparkler.utils.macro;

#if (macro || display)

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.ComplexTypeTools;
import sparkler.utils.macro.MacroUtils;

class ParticleModuleMacro {

	static public var moduleFields:Map<String, Array<Field>> = new Map();
	static public var moduleImports:Map<String, Array<ImportExpr>> = new Map();

	static public function build():Array<Field> {
		var fields = Context.getBuildFields();
		var cp:String = Context.getLocalModule();
		var li = Context.getLocalImports();

		var mf:Array<Field> = [];
		for (f in fields) {
			if(!MacroUtils.hasFieldMeta(f, 'virtual')) {
				mf.push(f);
			}
		}

		moduleFields.set(cp, mf);
		moduleImports.set(cp, li);

		return fields;
	}

}

#end
