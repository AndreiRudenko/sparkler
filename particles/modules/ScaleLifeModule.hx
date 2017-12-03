package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.ParticleData;
import particles.core.Components;
import particles.components.Life;


class ScaleLifeModule extends ParticleModule {


	public var initial_scale:Float;
	public var initial_scale_max:Float;
	public var end_scale:Float;
	public var end_scale_max:Float;

	var scale_delta:Array<Float>;
	var life:Components<Life>;
	var particles_data:Array<ParticleData>;


	public function new(_options:ScaleModuleOptions) {

		super();

		scale_delta = [];

		initial_scale = _options.initial_scale != null ? _options.initial_scale : 1;
		initial_scale_max = _options.initial_scale_max != null ? _options.initial_scale_max : 0;
		end_scale = _options.end_scale != null ? _options.end_scale : 1;
		end_scale_max = _options.end_scale_max != null ? _options.end_scale_max : 0;

	}

	override function init() {

		particles_data = emitter.particles_data;

		life = emitter.components.get(Life);
		if(life == null) {
			throw('LifeTimeModule is required for ScaleModule');
		}

		for (i in 0...particles.capacity) {
			scale_delta[i] = 0;
		}
	    
	}

	override function spawn(p:Particle) {

		var pd:ParticleData = particles_data[p.id];

		if(initial_scale_max != 0) {
			pd.s = emitter.random_float(initial_scale, initial_scale_max);
		} else {
			pd.s = initial_scale;
		}

		if(end_scale_max != 0) {
			scale_delta[p.id] = emitter.random_float(end_scale, end_scale_max) - pd.s;
		} else {
			scale_delta[p.id] = end_scale - pd.s;
		}

		if(scale_delta[p.id] != 0) {
			scale_delta[p.id] /= life.get(p).amount;
		}

	}

	override function update(dt:Float) {

		for (p in particles) {
			if(scale_delta[p.id] != 0) {
				particles_data[p.id].s += scale_delta[p.id] * dt;
			}
		}

	}


}


typedef ScaleModuleOptions = {

	@:optional var initial_scale : Float;
	@:optional var initial_scale_max : Float;
	@:optional var end_scale : Float;
	@:optional var end_scale_max : Float;

}


