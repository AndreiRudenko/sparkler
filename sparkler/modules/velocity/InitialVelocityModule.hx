package sparkler.modules.velocity;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(10)
@group('velocity')
class InitialVelocityModule extends ParticleModule<Particle<Velocity>> {

	public var initialVelocity:Vector2;

	function new(options:{?initialVelocity:{x:Float, y:Float}}) {
		initialVelocity = options.initialVelocity != null ? new Vector2(options.initialVelocity.x, options.initialVelocity.y) : new Vector2(0, 0);
	}

	override function onParticleSpawn(p:Particle<Velocity>) {
		if(localSpace) {
			p.velocity.x = initialVelocity.x;
			p.velocity.y = initialVelocity.y;
		} else {
			p.velocity.x = getRotateX(initialVelocity.x, initialVelocity.y);
			p.velocity.y = getRotateY(initialVelocity.x, initialVelocity.y);
		}
	}

	@filter('velocity')
	override function onPostParticleUpdate(p:Particle<Velocity>, elapsed:Float) {
		p.x += p.velocity.x * elapsed;
		p.y += p.velocity.y * elapsed;
	}

}