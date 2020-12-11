package sparkler.modules.helpers;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.components.Speed;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(70)
class UpdateSpeedModule extends ParticleModule<Particle<Speed, Velocity>> {

	override function onParticleUpdate(p:Particle<Speed, Velocity>, elapsed:Float) {
		updateParticleSpeed(p);
	}

	override function onParticleSpawn(p:Particle<Speed, Velocity>) {
		updateParticleSpeed(p);
	}

	inline function updateParticleSpeed(p:Particle<Speed, Velocity>) {
		p.speed = Math.sqrt(p.velocity.x * p.velocity.x + p.velocity.y * p.velocity.y);
	}

}