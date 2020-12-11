package sparkler.modules.helpers;

import sparkler.utils.Vector2;
import sparkler.components.LifeProgress;
import sparkler.components.Speed;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(0)
class LifeProgressModule extends ParticleModule<Particle<LifeProgress>> {

	override function onParticleUpdate(p:Particle<LifeProgress>, elapsed:Float) {
		p.lifeProgress = p.age / p.lifetime;
	}

}