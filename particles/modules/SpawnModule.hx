package particles.modules;

import particles.core.Particle;
import particles.core.ParticleData;
import particles.core.ParticleModule;


class SpawnModule extends ParticleModule {


	public function new() {

		super();

		priority = -999;
		override_priority = true;

	}

	override function spawn(p:Particle) {

		var pd:ParticleData = emitter.add_to_bacher(p);

		pd.x = emitter.system.position.x + emitter.position.x;
		pd.y = emitter.system.position.y + emitter.position.y;

	}

	override function unspawn(p:Particle) {

		emitter.remove_from_bacher(p);

	}


}


