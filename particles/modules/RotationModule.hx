package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.modules.SpawnModule;

import luxe.Vector;
import luxe.Color;
import phoenix.Texture;
import phoenix.Batcher;


class RotationModule extends ParticleModule {


	var rotation_delta:Array<Float>;
	var life:Array<Float>;
	var spawn_data:Array<SpawnData>;

	var initial_rotation:Float;
	var initial_rotation_max:Float;
	var end_rotation:Float;
	var end_rotation_max:Float;
	var rotation_random:Float;
		/** if this enabled, particle will rotate with end_rotation*360 during lifetime */
	var use_life:Bool;


	public function new(_options:RotationModuleOptions) {

		super();

		rotation_delta = [];

		initial_rotation = _options.initial_rotation != null ? _options.initial_rotation : 0;
		initial_rotation_max = _options.initial_rotation_max != null ? _options.initial_rotation_max : 0;
		end_rotation = _options.end_rotation != null ? _options.end_rotation : 1;
		end_rotation_max = _options.end_rotation_max != null ? _options.end_rotation_max : 0;
		rotation_random = _options.rotation_random != null ? _options.rotation_random : 0;
		use_life = _options.use_life != null ? _options.use_life : false;

	}

	override function spawn(p:Particle) {

		var sd:SpawnData = spawn_data[p.id];

		if(initial_rotation_max != 0) {
			sd.r = emitter.random_float(initial_rotation, initial_rotation_max) * 360;
		} else {
			sd.r = initial_rotation * 360;
		}

		if(end_rotation_max != 0) {
			rotation_delta[p.id] = emitter.random_float(end_rotation, end_rotation_max) * 360 - sd.r;
		} else {
			rotation_delta[p.id] = end_rotation * 360 - sd.r;
		}

		if(use_life) {
			if(rotation_delta[p.id] != 0) {
				rotation_delta[p.id] /= life[p.id];
			}
		}


	}

	override function init() {

		var sm:SpawnModule = emitter.get_module(SpawnModule);
		if(sm == null) {
			throw('SpawnModule is required for RotationModule');
		}
		spawn_data = sm.data;

		if(use_life) {
			var lm:LifeTimeModule = emitter.get_module(LifeTimeModule);
			if(lm == null) {
				throw('LifeTimeModule is required for RotationModule');
			}
			life = lm.life;
		}

		for (i in 0...particles.capacity) {
			rotation_delta[i] = 0;
		}
	    
	}

	override function update(dt:Float) {

		for (p in particles) {
			if(rotation_delta[p.id] != 0) {
				spawn_data[p.id].r += rotation_delta[p.id] * dt;
			}
			if(rotation_random > 0) {
				spawn_data[p.id].r += rotation_random * 360 * emitter.random_1_to_1() * dt;
			}
		}

	}


}


typedef RotationModuleOptions = {

	@:optional var initial_rotation : Float;
	@:optional var initial_rotation_max : Float;
	@:optional var end_rotation : Float;
	@:optional var end_rotation_max : Float;
	@:optional var rotation_random : Float;
	@:optional var use_life : Bool;

}


