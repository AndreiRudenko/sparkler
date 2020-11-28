package sparkler.modules;

import sparkler.ParticleModule;
import sparkler.Particle;

@group('spawn')
class SpawnModule extends ParticleModule<Particle> {

	override function onPreParticleSpawn(p:Particle) {
		if(localSpace) {
			p.x = 0;
			p.y = 0;
		} else {
			p.x = getTransformX(_x, _y);
			p.y = getTransformY(_x, _y);
		}
	}
	
}