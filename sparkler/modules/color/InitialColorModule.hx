package sparkler.modules.color;

import sparkler.utils.Color;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(5)
@group('color')
class InitialColorModule extends ParticleModule<Particle<Color>> {

	public var initialColor:Color;

	function new(options:{?initialColor:sparkler.utils.Color}) {
		initialColor = options.initialColor != null ? options.initialColor : new Color();
	}

	override function onParticleSpawn(p:Particle<Color>) {
		p.color = initialColor;
	}
	
}