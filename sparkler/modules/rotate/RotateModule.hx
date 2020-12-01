package sparkler.modules.rotate;

import sparkler.components.Rotation;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(3)
@group('rotate')
class RotateModule extends ParticleModule<Particle<Rotation>> {

	public var rotate:Float = 1.0;

	function new(options:{?rotate:Float}) {
		if(options.rotate != null) rotate = options.rotate;
	}

	override function onParticleSpawn(p:Particle<Rotation>) {
		p.rotation = rotate;
	}
	
}