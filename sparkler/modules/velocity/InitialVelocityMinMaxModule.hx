package sparkler.modules.velocity;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Bounds;

@priority(10)
@group('velocity')
@addModules(sparkler.modules.helpers.UpdatePosFromVelocityModule)
class InitialVelocityMinMaxModule extends ParticleModule<Particle<Velocity>> {

	public var initialVelocityMinMax:Bounds<Vector2>;

	function new(options:{?initialVelocityMinMax:{min:{x:Float, y:Float}, max:{x:Float, y:Float}}}) {
		initialVelocityMinMax = new Bounds(new Vector2(), new Vector2());
		if(options.initialVelocityMinMax != null) {
			initialVelocityMinMax.min.x = options.initialVelocityMinMax.min.x;
			initialVelocityMinMax.min.y = options.initialVelocityMinMax.min.y;
			initialVelocityMinMax.max.x = options.initialVelocityMinMax.max.x;
			initialVelocityMinMax.max.y = options.initialVelocityMinMax.max.y;
		}
	}

	override function onParticleSpawn(p:Particle<Velocity>) {
		p.velocity.x = randomFloat(initialVelocityMinMax.min.x, initialVelocityMinMax.max.x);
		p.velocity.y = randomFloat(initialVelocityMinMax.min.y, initialVelocityMinMax.max.y);
	}

}