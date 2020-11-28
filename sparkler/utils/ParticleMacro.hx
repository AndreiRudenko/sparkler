package sparkler.utils;

#if (macro || display)

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import sparkler.utils.MacroUtils;

class ParticleMacro {

	static public var typeName:String = "Particle";
	static public var particleIds:Map<String, String> = new Map();
	static public var particleTypes:Map<String, Array<Type>> = new Map();

	static var idx:Int = 0;
	static var particleTypeNames:Array<String> = ['ParticleBase'];

	static function build() {
		return switch (Context.getLocalType()) {
			case TInst(_.get() => {name: typeName}, types):
				buildParticle(types);
			default:
				throw false;
		}
	}

	static public function getParticleName(types:Array<Type>):String {
		var typesString = MacroUtils.getStringFromTypes(types);
		
		var name = '${typeName}_${typesString}';

		var uuid:String = particleIds.get(name);

		if(uuid == null) {
			uuid = '${typeName}_${idx++}';
			particleIds.set(name, uuid);
		}
		
		return uuid;
	}

	static public function buildParticle(types:Array<Type>) {
		if(types.length == 0) return Context.getType('sparkler.Particle.ParticleBase');
		
		var name = getParticleName(types);

		if(particleTypeNames.indexOf(name) == -1) {
			var fields = Context.getBuildFields();
			var pos = Context.currentPos();

			particleTypes.set(name, types);
			for (i in 0...types.length) {
				var expr:Expr;
				switch (types[i]) {
					case TType(t, p):
						switch (t.get().type) {
							case TAbstract(at, ap):
								switch (at.get().name) {
									case 'Float' | 'Int': expr = macro 0;
									case 'String': expr = macro '';
									default:
								}
							case TInst(at, ap):
							default:
						}
					default:
				}
				var info = MacroUtils.getPathInfo(types[i]);
				var compType = {pack: info.pack, name: info.module, sub: info.name};
				var compName = MacroUtils.toCamelCase(info.name);
				if(expr == null) expr = macro new $compType();
				fields.push(MacroUtils.buildVar(compName, [APublic], TPath(compType), expr));
			}

			Context.defineType({
				pack: ['sparkler'],
				name: name,
				pos: pos,
				meta: [],
				kind: TDClass({
					pack: ['sparkler'],
					name: "Particle",
					sub: "ParticleBase"
				}),
				fields: fields
			});

			particleTypeNames.push(name);

		}

		return Context.getType('sparkler.${name}');
	}

}

#end
