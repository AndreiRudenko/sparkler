package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.Components;
import particles.components.Life;
import particles.components.Velocity;
import particles.modules.VelocityModule;

import luxe.Vector;


class VelocityLifeModule extends VelocityModule {


	public var end_velocity(default, null):Vector;
	public var end_velocity_max:Vector;

	var velocity_delta:Array<Vector>;
	var life:Components<Life>;


	public function new(_options:VelocityLifeModuleOptions) {

		super(_options);

		velocity_delta = [];

		end_velocity = _options.end_velocity != null ? _options.end_velocity : new Vector();
		end_velocity_max = _options.end_velocity_max;

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

		if(end_velocity_max != null) {
			velocity_delta[p.id].x = emitter.random_float(end_velocity.x, end_velocity_max.x) - v.x;
			velocity_delta[p.id].y = emitter.random_float(end_velocity.y, end_velocity_max.y) - v.y;
		} else {
			velocity_delta[p.id].x = end_velocity.x - v.x;
			velocity_delta[p.id].y = end_velocity.y - v.y;
		}

		if(velocity_delta[p.id].lengthsq != 0) {
			velocity_delta[p.id].divideScalar(life.get(p).amount);
		}

	}

	override function init() {

		super.init();

		life = emitter.components.get(Life);
		if(life == null) {
			throw('LifeTimeModule is required for VelocityLifeModule');
		}

		for (i in 0...particles.capacity) {
			velocity_delta[i] = new Vector();
		}
	    
	}

	override function update(dt:Float) {

		var v:Vector;
		for (p in particles) {
			v = vel_comps.get(p);

			v.x += velocity_delta[p.id].x * dt;
			v.y += velocity_delta[p.id].y * dt;

			if(velocity_random != null) {
				v.x += velocity_random.x * emitter.random_1_to_1();
				v.y += velocity_random.y * emitter.random_1_to_1();
			}

		}

	}


}


typedef VelocityLifeModuleOptions = {

	> VelocityModuleOptions,
	
	@:optional var end_velocity : Vector;
	@:optional var end_velocity_max : Vector;

}


