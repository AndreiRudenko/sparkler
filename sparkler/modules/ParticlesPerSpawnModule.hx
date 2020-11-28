package sparkler.modules;

import sparkler.ParticleModule;
import sparkler.Particle;

@group('particlesPerSpawn')
class ParticlesPerSpawnModule extends ParticleModule<Particle> {

	public var particlesPerSpawn:Int = 1;

	function new(options:{?particlesPerSpawn:Int}) {
		if(options.particlesPerSpawn != null) particlesPerSpawn = options.particlesPerSpawn;
	}

	override function emit() {
		var count = this.particlesPerSpawn > cacheSize ? cacheSize : this.particlesPerSpawn;
		while(count > 0) {
			spawn();
			count--;
		}
	}
	
}