package sparkler.modules.helpers;

import sparkler.utils.Vector2;
import sparkler.components.AngularVelocity;
import sparkler.components.Rotation;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(110)
class UpdateRotationFromAngularVelocityModule extends ParticleModule<Particle<AngularVelocity, Rotation>> {

	override function onParticleUpdate(p:Particle<AngularVelocity, Rotation>, elapsed:Float) {
		p.rotation += p.angularVelocity * elapsed;
	}

}