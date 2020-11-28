package sparkler.modules;

import sparkler.utils.Color;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(5)
@group('color')
class ColorModule extends ParticleModule<Particle<Color>> {

	public var color:Color;

	function new(options:{?color:sparkler.utils.Color}) {
		color = options.color != null ? options.color : new Color();
	}

	override function onParticleSpawn(p:Particle<Color>) {
		p.color = color;
	}
	
}