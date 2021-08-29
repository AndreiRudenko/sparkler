package sparkler.modules.emit;

import sparkler.ParticleModule;
import sparkler.Particle;

@group('particlesPerEmit')
class ParticlesPerEmitModule extends ParticleModule<Particle> {

	public var particlesPerEmit:Int = 1;

	function new(options:{?particlesPerEmit:Int}) {
		if(options.particlesPerEmit != null) particlesPerEmit = options.particlesPerEmit;
	}

	override function onEmit() {
		var count = this.particlesPerEmit > cacheSize ? cacheSize : this.particlesPerEmit;
		while(count > 0) {
			spawn();
			count--;
		}
	}
	
}