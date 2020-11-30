package sparkler.modules.scale;

import sparkler.components.Scale;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.scale.ScaleOverLifetimeModule.ScaleOverLifetime;

class ScaleOverLifetime {

	public var start:Float = 1;
	public var end:Float = 1;
	public var ease:(v:Float)->Float;

	public function new() {}

}

@priority(3)
@group('scale')
class ScaleOverLifetimeModule extends ParticleModule<Particle<Scale>> {

	public var scaleOverLifetime:ScaleOverLifetime;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?scaleOverLifetime:{?ease:(v:Float)->Float, start:Float, end:Float}}) {
		scaleOverLifetime = new ScaleOverLifetime();

		if(options.scaleOverLifetime != null) {
			scaleOverLifetime.start = options.scaleOverLifetime.start;
			scaleOverLifetime.end = options.scaleOverLifetime.end;
			scaleOverLifetime.ease = options.scaleOverLifetime.ease;
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Scale>, elapsed:Float) {
		_lerp = p.age / p.lifetime;
	}

	override function onParticleUpdate(p:Particle<Scale>, elapsed:Float) {
		p.scale = lerpScale(_lerp);
	}

	override function onParticleSpawn(p:Particle<Scale>) {
		p.scale = scaleOverLifetime.start;
	}

	inline function lerpScale(t:Float):Float {
		if(scaleOverLifetime.ease != null) t = scaleOverLifetime.ease(t);
		return scaleOverLifetime.start + (scaleOverLifetime.end - scaleOverLifetime.start) * t;
	}
	
}