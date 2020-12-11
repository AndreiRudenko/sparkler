package sparkler.modules.life;

import sparkler.ParticleModule;
import sparkler.Particle;

@group('lifetime')
class LifetimeModule extends ParticleModule<Particle> {

	public var lifetime:Float = 1;

	function new(options:{?lifetime:Float}) {
		if(options.lifetime != null) lifetime = options.lifetime;
	}
	
	override function onParticleSpawn(p:Particle) {
		p.lifetime = lifetime;
	}

	override function onParticleUnspawn(p:Particle) {
		p.lifetime = -1;
	}
	
}