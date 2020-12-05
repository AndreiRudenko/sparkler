package sparkler.modules.rotate;

import sparkler.components.Rotation;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(3)
@group('rotate')
class InitialRotationModule extends ParticleModule<Particle<Rotation>> {

	public var initialRotation:Float = 1.0;

	function new(options:{?initialRotation:Float}) {
		if(options.initialRotation != null) initialRotation = options.initialRotation;
	}

	@filter('rotate') // TODO: ?
	override function onParticleSpawn(p:Particle<Rotation>) {
		p.rotation = initialRotation;
	}
	
}