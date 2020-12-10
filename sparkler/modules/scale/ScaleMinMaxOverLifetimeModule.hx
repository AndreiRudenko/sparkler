package sparkler.modules.scale;

import sparkler.components.Scale;
import sparkler.components.LifeProgress;
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

@priority(100)
@group('scale')
@addModules(sparkler.modules.helpers.LifeProgressModule)
class ScaleMinMaxOverLifetimeModule extends ParticleModule<Particle<Scale, ScaleRange, LifeProgress>> {

	public var scaleMinMaxOverLifetime:ScaleMinMaxOverLifetime;

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

	override function onParticleUpdate(p:Particle<Scale, ScaleRange, LifeProgress>, elapsed:Float) {
		p.scale = p.scaleRange.start + (p.scaleRange.end - p.scaleRange.start) * (scaleMinMaxOverLifetime.ease != null ? scaleMinMaxOverLifetime.ease(p.lifeProgress) : p.lifeProgress);
	}

	override function onParticleSpawn(p:Particle<Scale, ScaleRange, LifeProgress>) {
		p.scaleRange.start = randomFloat(scaleMinMaxOverLifetime.start.min, scaleMinMaxOverLifetime.start.max);
		p.scaleRange.end = randomFloat(scaleMinMaxOverLifetime.end.min, scaleMinMaxOverLifetime.end.max);
		p.scale = p.scaleRange.start;
	}
	
}