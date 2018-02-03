package sparkler.modules;

import sparkler.core.Particle;
import sparkler.core.ParticleModule;
import sparkler.core.ParticleData;
import sparkler.core.Components;
import sparkler.components.StartPos;

/*
	don't add this module manually to emitter, only from modules that have StartPos
 */

class StartPosModule extends ParticleModule {


	var spos_comps:Components<StartPos>;


	public function new() {

		super({});

		priority = -998; // after spawners

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

	override function onspawn(p:Particle) {

		var pd:ParticleData = emitter.particles_data[p.id];
		var sp:StartPos = spos_comps.get(p);
		sp.set_xy(pd.x, pd.y);

	}


}
