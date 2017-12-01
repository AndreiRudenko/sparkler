package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.modules.SpawnModule;
import particles.modules.VelocityModule;

import luxe.Vector;
import luxe.Color;
import phoenix.Texture;
import phoenix.Batcher;


class GravityModule extends ParticleModule {


	public var gravity:Vector;

	var vel_data:Array<Vector>;


	public function new(_options:GravityModuleOptions) {

		super();

		gravity = _options.gravity != null ? _options.gravity : new Vector(0, 98);

	}

	override function init() {

		var vm:VelocityModule = emitter.get_module(VelocityModule);
		if(vm == null) {
			throw('VelocityModule is required for GravityModule');
		}
		vel_data = vm.data;
	    
	}

	override function update(dt:Float) {

		var vel:Vector;
		for (p in particles) {
			vel = vel_data[p.id];
			vel.x += gravity.x * dt;
			vel.y += gravity.y * dt;
		}

	}


}


typedef GravityModuleOptions = {

	@:optional var gravity : Vector;

}


