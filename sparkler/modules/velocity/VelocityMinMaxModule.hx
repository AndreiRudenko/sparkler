package sparkler.modules.velocity;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Bounds;

@priority(10)
@group('velocity')
class VelocityMinMaxModule extends ParticleModule<Particle<Velocity>> {

	public var velocityMinMax:Bounds<Vector2>;

	function new(options:{?velocityMinMax:{min:{x:Float, y:Float}, max:{x:Float, y:Float}}}) {
		velocityMinMax = new Bounds(new Vector2(), new Vector2());
		if(options.velocityMinMax != null) {
			velocityMinMax.min.x = options.velocityMinMax.min.x;
			velocityMinMax.min.y = options.velocityMinMax.min.y;
			velocityMinMax.max.x = options.velocityMinMax.max.x;
			velocityMinMax.max.y = options.velocityMinMax.max.y;
		}
	}

	override function onParticleSpawn(p:Particle<Velocity>) {
		p.velocity.x = randomFloat(velocityMinMax.min.x, velocityMinMax.max.x);
		p.velocity.y = randomFloat(velocityMinMax.min.y, velocityMinMax.max.y);
	}

	@filter('velocity')
	override function onPostParticleUpdate(p:Particle<Velocity>, elapsed:Float) {
		p.x += p.velocity.x * elapsed;
		p.y += p.velocity.y * elapsed;
	}

}