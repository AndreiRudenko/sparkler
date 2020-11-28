package sparkler.utils;

#if (macro || display)

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.ComplexTypeTools;
import sparkler.utils.MacroUtils;

class ParticleInjectModuleMacro {

	// static public var moduleFields:Map<String, Array<Field>> = new Map();
	// static public var moduleImports:Map<String, Array<ImportExpr>> = new Map();
	// static public var test:Array<()->Void> = [];

	static public function build():Array<Field> {
		var fields = Context.getBuildFields();
		// var pos = Context.currentPos();
		// var t = Context.getLocalType();
		// var tp = MacroUtils.getTypePath(Context.getLocalType());

		// var nameVar = MacroUtils.buildVar('name', [Access.AStatic, Access.APublic], macro: String, macro $v{tp});
		// fields.push(nameVar);
		// trace(tp);
		// trace(fields);
		// var tp = {pack: ['sparkler', 'modules'], name: 'SpriteRenderer'};
		// trace(macro function() {});
		// test.push(Context.parse('sparkler.modules.SpriteRenderer.inject', pos));
		// trace(fields);
		// var cp:String = Context.getLocalModule();
		// var li = Context.getLocalImports();

		// moduleFields.set(cp, fields);
		// moduleImports.set(cp, li);

		return fields;
	}

}

// typedef ModuleType = {
// 	name:String, 
// 	// inject:(oField:ObjectField, options:ParticleEmitterBuildOptions)->Void
// }

#end
