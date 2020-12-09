package sparkler.modules.rotate;

import sparkler.components.Rotation;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Bounds;

@priority(3)
@group('rotation')
class InitialRotationMinMaxModule extends ParticleModule<Particle<Rotation>> {

	public var initialRotationMinMax:Bounds<Float>;

	function new(options:{?initialRotationMinMax:{min:Float, max:Float}}) {
		initialRotationMinMax = new Bounds(1.0, 1.0);
		if(options.initialRotationMinMax != null) {
			initialRotationMinMax.min = options.initialRotationMinMax.min;
			initialRotationMinMax.max = options.initialRotationMinMax.max;
		}
	}

	override function onParticleSpawn(p:Particle<Rotation>) {
		p.rotation = randomFloat(initialRotationMinMax.min, initialRotationMinMax.max);
	}

}