package sparkler.modules.rotate;

import sparkler.utils.Vector2;
import sparkler.components.AngularVelocity;
import sparkler.components.Rotation;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(50)
class UpdateAngularVelocityModule extends ParticleModule<Particle<AngularVelocity, Rotation>> {

	override function onPostParticleUpdate(p:Particle<AngularVelocity, Rotation>, elapsed:Float) {
		p.rotation += p.angularVelocity * elapsed;
	}

}