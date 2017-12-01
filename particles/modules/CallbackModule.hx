package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.ParticleEmitter;


class CallbackModule extends ParticleModule {


	public var onspawn:Particle->ParticleEmitter->Void;
	public var onunspawn:Particle->ParticleEmitter->Void;


	public function new(_options:ForceModuleOptions) {

		super();

		onspawn = _options.onspawn;
		onunspawn = _options.onunspawn;

	}

	override function spawn(p:Particle) {

		if(onspawn != null) {
			onspawn(p, emitter);
		}

	}

	override function unspawn(p:Particle) {
		
		if(unspawn != null) {
			unspawn(p, emitter);
		}
		
	}


}


typedef ForceModuleOptions = {

	@:optional var onspawn : Particle->ParticleEmitter->Void;
	@:optional var onunspawn : Particle->ParticleEmitter->Void;

}

