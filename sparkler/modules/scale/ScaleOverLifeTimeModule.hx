package sparkler.modules.scale;

import sparkler.components.Scale;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.scale.ScaleOverLifeTimeModule.ScaleOverLifeTime;

class ScaleOverLifeTime {

	public var start:Float = 1;
	public var end:Float = 1;
	public var ease:(v:Float)->Float;

	public function new() {}

}

@priority(3)
@group('scale')
class ScaleOverLifeTimeModule extends ParticleModule<Particle<Scale>> {

	public var scaleOverLifeTime:ScaleOverLifeTime;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?scaleOverLifeTime:{?ease:(v:Float)->Float, start:Float, end:Float}}) {
		scaleOverLifeTime = new ScaleOverLifeTime();

		if(options.scaleOverLifeTime != null) {
			scaleOverLifeTime.start = options.scaleOverLifeTime.start;
			scaleOverLifeTime.end = options.scaleOverLifeTime.end;
			scaleOverLifeTime.ease = options.scaleOverLifeTime.ease;
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Scale>, elapsed:Float) {
		_lerp = p.age / p.lifeTime;
	}

	override function onParticleUpdate(p:Particle<Scale>, elapsed:Float) {
		p.scale = interpolate(_lerp);
	}

	override function onParticleSpawn(p:Particle<Scale>) {
		p.scale = scaleOverLifeTime.start;
	}

	inline function interpolate(t:Float):Float {
		if(scaleOverLifeTime.ease != null) t = scaleOverLifeTime.ease(t);
		return scaleOverLifeTime.start + (scaleOverLifeTime.end - scaleOverLifeTime.start) * t;
	}
	
}