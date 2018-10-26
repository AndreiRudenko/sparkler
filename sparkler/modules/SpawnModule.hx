package sparkler.modules;

import sparkler.core.Particle;
import sparkler.core.ParticleData;
import sparkler.core.ParticleModule;


class SpawnModule extends ParticleModule {


	public function new(?_options:ParticleModuleOptions) {

		super(_options);

		_priority = -999;

	}

	override function onspawn(p:Particle) {

		emitter.show_particle(p);
		
		var pd:ParticleData = emitter.get_particle_data(p);

		pd.x = emitter.system.pos.x + emitter.pos.x;
		pd.y = emitter.system.pos.y + emitter.pos.y;

	}

	override function onunspawn(p:Particle) {

		emitter.hide_particle(p);

	}


}


