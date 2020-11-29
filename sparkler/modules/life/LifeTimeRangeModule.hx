package sparkler.modules.life;

import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Range;

@group('lifeTime')
class LifeTimeRangeModule extends ParticleModule<Particle> {

	public var lifeTimeRange:Range<Float>;

	function new(options:{?lifeTimeRange:{min:Float, max:Float}}) {
		lifeTimeRange = new Range(1.0, 1.0);
		if(options.lifeTimeRange != null) {
			lifeTimeRange.min = options.lifeTimeRange.min;
			lifeTimeRange.max = options.lifeTimeRange.max;
		}
	}
	
	override function onPreParticleSpawn(p:Particle) {
		p.lifeTime = randomFloat(lifeTimeRange.min, lifeTimeRange.max);
	}

	override function onParticleUnspawn(p:Particle) {
		p.lifeTime = -1;
	}
	
}