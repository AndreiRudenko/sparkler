package sparkler.modules;

import sparkler.components.Scale;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(3)
@group('scale')
class ScaleModule extends ParticleModule<Particle<Scale>> {

	public var scale:Scale = 1.0;

	function new(options:{?scale:Float}) {
		if(options.scale != null) scale = options.scale;
	}

	override function onParticleSpawn(p:Particle<Scale>) {
		p.scale = scale;
	}
	
}