package sparkler.modules.scale;

import sparkler.components.Scale;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(3)
@group('scale')
class InitialScaleModule extends ParticleModule<Particle<Scale>> {

	public var initialScale:Scale = 1.0;

	function new(options:{?initialScale:Float}) {
		if(options.initialScale != null) initialScale = options.initialScale;
	}

	override function onParticleSpawn(p:Particle<Scale>) {
		p.scale = initialScale;
	}
	
}