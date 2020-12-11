package sparkler.modules.helpers;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(60)
class UpdatePosFromVelocityModule extends ParticleModule<Particle<Velocity>> {

	override function onParticleUpdate(p:Particle<Velocity>, elapsed:Float) {
		p.x += p.velocity.x * elapsed;
		p.y += p.velocity.y * elapsed;
	}

}