package sparkler.modules.life;

import sparkler.ParticleModule;
import sparkler.Particle;

@group('lifeTime')
class LifeTimeModule extends ParticleModule<Particle> {

	public var lifeTime:Float = 1;

	function new(options:{?lifeTime:Float}) {
		if(options.lifeTime != null) lifeTime = options.lifeTime;
	}
	
	override function onPreParticleSpawn(p:Particle) {
		p.lifeTime = lifeTime;
	}

	override function onParticleUnspawn(p:Particle) {
		p.lifeTime = -1;
	}
	
}