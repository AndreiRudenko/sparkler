package sparkler.modules.scale;

import sparkler.components.Scale;
import sparkler.components.ScaleRange;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Bounds;
import sparkler.modules.scale.ScaleMinMaxOverLifetimeModule.ScaleMinMaxOverLifetime;

class ScaleMinMaxOverLifetime {

	public var start:Bounds<Float>;
	public var end:Bounds<Float>;
	public var ease:(v:Float)->Float;

	public function new() {
		start = new Bounds(1.0, 1.0);
		end = new Bounds(1.0, 1.0);
	}

}

@priority(3)
@group('scale')
class ScaleMinMaxOverLifetimeModule extends ParticleModule<Particle<Scale, ScaleRange>> {

	public var scaleMinMaxOverLifetime:ScaleMinMaxOverLifetime;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?scaleMinMaxOverLifetime:{?ease:(v:Float)->Float, start:{min:Float, max:Float}, end:{min:Float, max:Float}}}) {
		scaleMinMaxOverLifetime = new ScaleMinMaxOverLifetime();

		if(options.scaleMinMaxOverLifetime != null) {
			scaleMinMaxOverLifetime.start.min = options.scaleMinMaxOverLifetime.start.min;
			scaleMinMaxOverLifetime.start.max = options.scaleMinMaxOverLifetime.start.max;
			scaleMinMaxOverLifetime.end.min = options.scaleMinMaxOverLifetime.end.min;
			scaleMinMaxOverLifetime.end.max = options.scaleMinMaxOverLifetime.end.max;
			scaleMinMaxOverLifetime.ease = options.scaleMinMaxOverLifetime.ease;
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Scale, ScaleRange>, elapsed:Float) {
		_lerp = p.age / p.lifetime;
	}

	override function onParticleUpdate(p:Particle<Scale, ScaleRange>, elapsed:Float) {
		p.scale = interpolate(p.scaleRange.start, p.scaleRange.end, _lerp);
	}

	override function onParticleSpawn(p:Particle<Scale, ScaleRange>) {
		p.scaleRange.start = randomFloat(scaleMinMaxOverLifetime.start.min, scaleMinMaxOverLifetime.start.max);
		p.scaleRange.end = randomFloat(scaleMinMaxOverLifetime.end.min, scaleMinMaxOverLifetime.end.max);
		p.scale = p.scaleRange.start;
	}

	inline function interpolate(start:Float, end:Float, t:Float):Float {
		if(scaleMinMaxOverLifetime.ease != null) t = scaleMinMaxOverLifetime.ease(t);
		return start + (end - start) * t;
	}
	
}