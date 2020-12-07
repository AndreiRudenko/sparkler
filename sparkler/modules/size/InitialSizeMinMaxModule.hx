package sparkler.modules.size;

import sparkler.utils.Vector2;
import sparkler.components.Size;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Bounds;

@priority(3)
@group('size')
class InitialSizeMinMaxModule extends ParticleModule<Particle<Size>> {

	public var initialSizeMinMax:Bounds<Vector2>;

	function new(options:{?initialSizeMinMax:{min:{x:Float, y:Float}, max:{x:Float, y:Float}}}) {
		initialSizeMinMax = new Bounds(new Vector2(), new Vector2());
		if(options.initialSizeMinMax != null) {
			initialSizeMinMax.min.x = options.initialSizeMinMax.min.x;
			initialSizeMinMax.min.y = options.initialSizeMinMax.min.y;
			initialSizeMinMax.max.x = options.initialSizeMinMax.max.x;
			initialSizeMinMax.max.y = options.initialSizeMinMax.max.y;
		}
	}

	override function onParticleSpawn(p:Particle<Size>) {
		p.size.x = randomFloat(initialSizeMinMax.min.x, initialSizeMinMax.max.x);
		p.size.y = randomFloat(initialSizeMinMax.min.y, initialSizeMinMax.max.y);
	}

}