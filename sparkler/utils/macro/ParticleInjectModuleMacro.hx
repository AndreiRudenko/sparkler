package sparkler.utils.macro;

#if (macro || display)

import haxe.macro.Context;

class ParticleInjectModuleMacro {

	static public function build() {
		var fields = Context.getBuildFields();
		return fields;
	}

}

#end
