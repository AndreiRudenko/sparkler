package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.Components;
import particles.components.Velocity;
import particles.modules.VelocityUpdateModule;

import luxe.Vector;
import luxe.Color;
import phoenix.Texture;
import phoenix.Batcher;


class ForceModule extends ParticleModule {


	public var force(default, null):Vector;
	public var force_random:Vector;

	var vel_comps:Components<Velocity>;


	public function new(_options:ForceModuleOptions) {

		super();

		force = _options.force != null ? _options.force : new Vector();
		force_random = _options.force_random;

	}

	override function init() {

	    if(emitter.get_module(VelocityUpdateModule) == null) {
			emitter.add_module(new VelocityUpdateModule());
		}

		vel_comps = emitter.components.get(Velocity);

	}

	override function unspawn(p:Particle) {

		var v:Velocity = vel_comps.get(p);
		v.set_xy(0,0);
		
	}

	override function update(dt:Float) {

		var vel:Vector;
		for (p in particles) {
			vel = vel_comps.get(p);
			vel.x += force.x * dt;
			vel.y += force.y * dt;
			if(force_random != null) {
				vel.x += force_random.x * emitter.random_1_to_1() * dt;
				vel.y += force_random.y * emitter.random_1_to_1() * dt;
			}
		}

	}


}


typedef ForceModuleOptions = {

	@:optional var force : Vector;
	@:optional var force_random : Vector;

}


