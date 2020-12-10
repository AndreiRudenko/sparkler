package sparkler.modules.rotate;

import sparkler.components.LifeProgress;
import sparkler.components.Rotation;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.rotate.RotateOverLifetimeModule.RotateOverLifetime;

class RotateOverLifetime {

	public var start:Float = 0;
	public var end:Float = 0;
	public var ease:(v:Float)->Float;

	public function new() {}

}

@priority(3)
@group('rotate')
@addModules(sparkler.modules.life.LifeProgressModule)
class RotateOverLifetimeModule extends ParticleModule<Particle<Rotation, LifeProgress>> {

	public var rotateOverLifetime:RotateOverLifetime;

	function new(options:{?rotateOverLifetime:{?ease:(v:Float)->Float, start:Float, end:Float}}) {
		rotateOverLifetime = new RotateOverLifetime();
		if(options.rotateOverLifetime != null) {
			rotateOverLifetime.start = options.rotateOverLifetime.start;
			rotateOverLifetime.end = options.rotateOverLifetime.end;
			rotateOverLifetime.ease = options.rotateOverLifetime.ease;
		}
	}

	override function onParticleUpdate(p:Particle<Rotation, LifeProgress>, elapsed:Float) {
		p.rotation = rotateOverLifetime.start + (rotateOverLifetime.end - rotateOverLifetime.start) * (rotateOverLifetime.ease != null ? rotateOverLifetime.ease(p.lifeProgress) : p.lifeProgress);
	}

	override function onParticleSpawn(p:Particle<Rotation, LifeProgress>) {
		p.rotation = rotateOverLifetime.start;
	}
	
}