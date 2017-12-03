package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.ParticleData;
import particles.core.Components;
import particles.components.StartPos;

/*
	don't add this module manually to emitter, only from modules that have StartPos
 */

class StartPosModule extends ParticleModule {


	var spos_comps:Components<StartPos>;


	public function new() {

		super();

		priority = -998; // after spawners
		override_priority = true;

	}

	override function init() {

		spos_comps = emitter.components.get(StartPos);
	    
		if(spos_comps == null) {
			spos_comps = emitter.components.set(
				particles, 
				StartPos, 
				function() {
					return new StartPos();
				}
			);
		}

	}

	override function spawn(p:Particle) {

		var pd:ParticleData = emitter.particles_data[p.id];
		var sp:StartPos = spos_comps.get(p);
		sp.set_xy(pd.x, pd.y);

	}


}
