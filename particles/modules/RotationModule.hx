package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.ParticleData;
import particles.core.Components;
import particles.components.Life;


class RotationModule extends ParticleModule {


	public var initial_rotation:Float;
	public var initial_rotation_max:Float;
	public var end_rotation:Float;
	public var end_rotation_max:Float;
	public var rotation_random:Float;

	var rotation_delta:Array<Float>;
	var life:Components<Life>;
	var particles_data:Array<ParticleData>;
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

		var pd:ParticleData = particles_data[p.id];

		if(initial_rotation_max != 0) {
			pd.r = emitter.random_float(initial_rotation, initial_rotation_max) * 360;
		} else {
			pd.r = initial_rotation * 360;
		}

		if(end_rotation_max != 0) {
			rotation_delta[p.id] = emitter.random_float(end_rotation, end_rotation_max) * 360 - pd.r;
		} else {
			rotation_delta[p.id] = end_rotation * 360 - pd.r;
		}

		if(life != null) {
			if(rotation_delta[p.id] != 0) {
				rotation_delta[p.id] /= life.get(p).amount;
			}
		}

	}

	override function init() {

		particles_data = emitter.particles_data;

		if(use_life) {
			life = emitter.components.get(Life);
			// if(life == null) {
			// 	throw('LifeModule is required for using life in RotationModule');
			// }
		}

		for (i in 0...particles.capacity) {
			rotation_delta[i] = 0;
		}
	    
	}

	override function update(dt:Float) {

		for (p in particles) {
			if(rotation_delta[p.id] != 0) {
				particles_data[p.id].r += rotation_delta[p.id] * dt;
			}
			if(rotation_random > 0) {
				particles_data[p.id].r += rotation_random * 360 * emitter.random_1_to_1() * dt;
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


