package sparkler.modules.rotate;

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
class RotateOverLifetimeModule extends ParticleModule<Particle<Rotation>> {

	public var rotateOverLifetime:RotateOverLifetime;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?rotateOverLifetime:{?ease:(v:Float)->Float, start:Float, end:Float}}) {
		rotateOverLifetime = new RotateOverLifetime();

		if(options.rotateOverLifetime != null) {
			rotateOverLifetime.start = options.rotateOverLifetime.start;
			rotateOverLifetime.end = options.rotateOverLifetime.end;
			rotateOverLifetime.ease = options.rotateOverLifetime.ease;
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Rotation>, elapsed:Float) {
		_lerp = p.age / p.lifetime;
	}

	override function onParticleUpdate(p:Particle<Rotation>, elapsed:Float) {
		p.rotation = lerpRotate(_lerp);
	}

	override function onParticleSpawn(p:Particle<Rotation>) {
		p.rotation = rotateOverLifetime.start;
	}

	inline function lerpRotate(t:Float):Float {
		if(rotateOverLifetime.ease != null) t = rotateOverLifetime.ease(t);
		return rotateOverLifetime.start + (rotateOverLifetime.end - rotateOverLifetime.start) * t;
	}
	
}