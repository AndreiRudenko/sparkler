package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.Components;
import particles.components.Velocity;
import particles.modules.VelocityUpdateModule;

import luxe.Vector;


class VelocityModule extends ParticleModule {


	public var initial_velocity(default, null):Vector;
	public var initial_velocity_max:Vector;
	public var velocity_random:Vector;

	var vel_comps:Components<Velocity>;


	public function new(_options:VelocityModuleOptions) {

		super();

		initial_velocity = _options.initial_velocity != null ? _options.initial_velocity : new Vector();
		initial_velocity_max = _options.initial_velocity_max;
		velocity_random = _options.velocity_random;

	}

	override function init() {

		if(emitter.get_module(VelocityUpdateModule) == null) {
			emitter.add_module(new VelocityUpdateModule());
		}

		vel_comps = emitter.components.get(Velocity);

	}

	override function spawn(p:Particle) {

		var v:Velocity = vel_comps.get(p);
		if(initial_velocity_max != null) {
			v.x = emitter.random_float(initial_velocity.x, initial_velocity_max.x);
			v.y = emitter.random_float(initial_velocity.y, initial_velocity_max.y);
		} else {
			v.x = initial_velocity.x;
			v.y = initial_velocity.y;
		}

	}

	override function update(dt:Float) {

		var v:Velocity;
		for (p in particles) {
			v = vel_comps.get(p);

			if(velocity_random != null) {
				v.x += velocity_random.x * emitter.random_1_to_1();
				v.y += velocity_random.y * emitter.random_1_to_1();
			}
		}

	}


}


typedef VelocityModuleOptions = {

	@:optional var initial_velocity : Vector;
	@:optional var initial_velocity_max : Vector;
	@:optional var velocity_random : Vector;

}


