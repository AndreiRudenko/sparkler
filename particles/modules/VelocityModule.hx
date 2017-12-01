package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.modules.SpawnModule;

import luxe.Vector;
import luxe.Color;
import phoenix.Texture;
import phoenix.Batcher;


class VelocityModule extends ParticleModule {


	public var data:Array<Vector>;

	var spawn_data:Array<SpawnData>;

	var initial_velocity:Vector;
	var initial_velocity_variance:Vector;
	var velocity_random:Vector;



	public function new(_options:VelocityModuleOptions) {

		super();

		data = [];

		initial_velocity = _options.initial_velocity != null ? _options.initial_velocity : new Vector();
		initial_velocity_variance = _options.initial_velocity_variance;
		velocity_random = _options.velocity_random;

	}

	override function spawn(p:Particle) {

		var v:Vector = data[p.id];
		v.copy_from(initial_velocity);
		if(initial_velocity_variance != null) {
			v.x += initial_velocity_variance.x * emitter.random_1_to_1();
			v.y += initial_velocity_variance.y * emitter.random_1_to_1();
		}

	}

	override function init() {

		var sm:SpawnModule = emitter.get_module(SpawnModule);
		if(sm == null) {
			throw('SpawnModule is required for VelocityModule');
		}
		spawn_data = sm.data;

		for (i in 0...particles.capacity) {
			data[i] = new Vector();
		}
	    
	}

	override function update(dt:Float) {

		var v:Vector;
		var sd:SpawnData;
		for (p in particles) {
			v = data[p.id];
			sd = spawn_data[p.id];

			if(velocity_random != null) {
				v.x += velocity_random.x * emitter.random_1_to_1();
				v.y += velocity_random.y * emitter.random_1_to_1();
			}

			sd.x += v.x * dt;
			sd.y += v.y * dt;
		}

	}


}


typedef VelocityModuleOptions = {

	@:optional var initial_velocity : Vector;
	@:optional var initial_velocity_variance : Vector;
	@:optional var velocity_random : Vector;

}


