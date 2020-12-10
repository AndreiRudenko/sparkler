package sparkler.modules.scale;

import sparkler.components.Scale;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Bounds;

@priority(100)
@group('scale')
class InitialScaleMinMaxModule extends ParticleModule<Particle<Scale>> {

	public var initialScaleMinMax:Bounds<Float>;

	function new(options:{?initialScaleMinMax:{min:Float, max:Float}}) {
		initialScaleMinMax = new Bounds(1.0, 1.0);
		if(options.initialScaleMinMax != null) {
			initialScaleMinMax.min = options.initialScaleMinMax.min;
			initialScaleMinMax.max = options.initialScaleMinMax.max;
		}
	}

	override function onParticleSpawn(p:Particle<Scale>) {
		p.scale = randomFloat(initialScaleMinMax.min, initialScaleMinMax.max);
	}

}