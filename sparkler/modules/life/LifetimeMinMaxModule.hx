package sparkler.modules.life;

import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Bounds;

@group('lifetime')
class LifetimeMinMaxModule extends ParticleModule<Particle> {

	public var lifetimeMinMax:Bounds<Float>;

	function new(options:{?lifetimeMinMax:{min:Float, max:Float}}) {
		lifetimeMinMax = new Bounds(1.0, 1.0);
		if(options.lifetimeMinMax != null) {
			lifetimeMinMax.min = options.lifetimeMinMax.min;
			lifetimeMinMax.max = options.lifetimeMinMax.max;
		}
	}
	
	override function onParticleSpawn(p:Particle) {
		p.lifetime = randomFloat(lifetimeMinMax.min, lifetimeMinMax.max);
	}

	override function onParticleUnspawn(p:Particle) {
		p.lifetime = -1;
	}
	
}