package sparkler.utils.macro;

#if (macro || display)

import haxe.macro.Context;

class ParticleInjectModuleMacro {

	static public function build():Array<Field> {
		var fields = Context.getBuildFields();
		return fields;
	}

}

#end
