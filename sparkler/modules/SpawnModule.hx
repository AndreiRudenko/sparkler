package sparkler.modules;

import sparkler.core.Particle;
import sparkler.core.ParticleData;
import sparkler.core.ParticleModule;


class SpawnModule extends ParticleModule {


	public function new() {

		super();

		priority = -999;

	}

	override function onspawn(p:Particle) {

		var pd:ParticleData = emitter.add_to_bacher(p);

		pd.x = emitter.system.position.x + emitter.position.x;
		pd.y = emitter.system.position.y + emitter.position.y;

	}

	override function onunspawn(p:Particle) {

		emitter.remove_from_bacher(p);

	}


}


