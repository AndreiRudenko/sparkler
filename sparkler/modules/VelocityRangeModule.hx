package sparkler.modules;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Range;

@priority(10)
@group('velocity')
class VelocityRangeModule extends ParticleModule<Particle<Velocity>> {

	public var velocityRange:Range<Vector2>;

	function new(options:{?velocityRange:{min:{x:Float, y:Float}, max:{x:Float, y:Float}}}) {
		velocityRange = new Range(new Vector2(), new Vector2());
		if(options.velocityRange != null) {
			velocityRange.min.x = options.velocityRange.min.x;
			velocityRange.min.y = options.velocityRange.min.y;
			velocityRange.max.x = options.velocityRange.max.x;
			velocityRange.max.y = options.velocityRange.max.y;
		}
	}

	override function onParticleSpawn(p:Particle<Velocity>) {
		p.velocity.x = randomFloat(velocityRange.min.x, velocityRange.max.x);
		p.velocity.y = randomFloat(velocityRange.min.y, velocityRange.max.y);
	}

	@filter('velocity')
	override function onPostParticleUpdate(p:Particle<Velocity>, elapsed:Float) {
		p.x += p.velocity.x * elapsed;
		p.y += p.velocity.y * elapsed;
	}

}