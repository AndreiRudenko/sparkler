package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.modules.SpawnModule;

import luxe.Vector;
import luxe.Color;
import phoenix.Texture;
import phoenix.Batcher;


class ScaleModule extends ParticleModule {


	var scale_delta:Array<Float>;
	var life:Array<Float>;
	var spawn_data:Array<SpawnData>;

	var initial_scale:Float;
	var initial_scale_max:Float;
	var end_scale:Float;
	var end_scale_max:Float;


	public function new(_options:ScaleModuleOptions) {

		super();

		scale_delta = [];

		initial_scale = _options.initial_scale != null ? _options.initial_scale : 1;
		initial_scale_max = _options.initial_scale_max != null ? _options.initial_scale_max : 0;
		end_scale = _options.end_scale != null ? _options.end_scale : 1;
		end_scale_max = _options.end_scale_max != null ? _options.end_scale_max : 0;

	}

	override function spawn(p:Particle) {

		var sd:SpawnData = spawn_data[p.id];
		var lf:Float = life[p.id];

		if(initial_scale_max != 0) {
			sd.s = emitter.random_float(initial_scale, initial_scale_max);
		} else {
			sd.s = initial_scale;
		}

		if(end_scale_max != 0) {
			scale_delta[p.id] = emitter.random_float(end_scale, end_scale_max) - sd.s;
		} else {
			scale_delta[p.id] = end_scale - sd.s;
		}

		if(scale_delta[p.id] != 0) {
			scale_delta[p.id] /= lf;
		}


	}

	override function init() {

		var sm:SpawnModule = emitter.get_module(SpawnModule);
		if(sm == null) {
			throw('SpawnModule is required for ScaleModule');
		}
		spawn_data = sm.data;

		var lm:LifeTimeModule = emitter.get_module(LifeTimeModule);
		if(lm == null) {
			throw('LifeTimeModule is required for ScaleModule');
		}
		life = lm.life;

		for (i in 0...particles.capacity) {
			scale_delta[i] = 0;
		}
	    
	}

	override function update(dt:Float) {

		for (p in particles) {
			if(scale_delta[p.id] != 0) {
				spawn_data[p.id].s += scale_delta[p.id] * dt;
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


