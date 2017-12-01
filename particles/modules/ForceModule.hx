package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.modules.SpawnModule;
import particles.modules.VelocityModule;
import particles.modules.VelocityLifeModule;

import luxe.Vector;
import luxe.Color;
import phoenix.Texture;
import phoenix.Batcher;


class ForceModule extends ParticleModule {


	public var force:Vector;
	public var force_random:Vector;

	var vel_data:Array<Vector>;


	public function new(_options:ForceModuleOptions) {

		super();

		force = _options.force != null ? _options.force : new Vector();
		force_random = _options.force_random;

	}

	override function init() {

		var vm = emitter.get_module(VelocityModule);
		if(vm == null) {
			vm = emitter.get_module(VelocityLifeModule);
		}

		if(vm == null) {
			throw('VelocityModule is required for ForceModule');
		}
		
		vel_data = vm.data;
	    
	}

	override function update(dt:Float) {

		var vel:Vector;
		for (p in particles) {
			vel = vel_data[p.id];
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


