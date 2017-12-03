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


class GravityModule extends ParticleModule {


	public var gravity(default, null):Vector;

	var vel_comps:Components<Velocity>;


	public function new(_options:GravityModuleOptions) {

		super();

		gravity = _options.gravity != null ? _options.gravity : new Vector(0, 98);

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
			vel.x += gravity.x * dt;
			vel.y += gravity.y * dt;
		}

	}


}


typedef GravityModuleOptions = {

	@:optional var gravity : Vector;

}


