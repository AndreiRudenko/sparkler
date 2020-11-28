package sparkler.modules;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(10)
@group('velocity')
class VelocityModule extends ParticleModule<Particle<Velocity>> {

	public var velocity:Vector2;

	function new(options:{?velocity:{x:Float, y:Float}}) {
		velocity = options.velocity != null ? new Vector2(options.velocity.x, options.velocity.y) : new Vector2(0, 0);
	}

	override function onParticleSpawn(p:Particle<Velocity>) {
		p.velocity.x = this.velocity.x;
		p.velocity.y = this.velocity.y;
	}

	@filter('velocity')
	override function onPostParticleUpdate(p:Particle<Velocity>, elapsed:Float) {
		p.x += p.velocity.x * elapsed;
		p.y += p.velocity.y * elapsed;
	}

}