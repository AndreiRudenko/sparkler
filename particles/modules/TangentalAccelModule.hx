package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.ParticleData;
import particles.core.Components;
import particles.components.Velocity;
import particles.components.StartPos;
import particles.modules.VelocityUpdateModule;
import particles.modules.StartPosModule;

import luxe.Vector;


class TangentalAccelModule extends ParticleModule {


	public var accel:Float;
	public var accel_variance:Float;
	// public var accel_random:Float;

	var vel_comps:Components<Velocity>;
	var spos_comps:Components<StartPos>;
	var accel_data:Array<Float>;
	var particles_data:Array<ParticleData>;


	public function new(_options:TangentalAccelModuleOptions) {

		super();

		accel_data = [];

		accel = _options.accel != null ? _options.accel : 60;
		accel_variance = _options.accel_variance != null ? _options.accel_variance : 0;
		// accel_random = _options.accel_random != null ? _options.accel_random : 0;

	}

	override function init() {

		if(emitter.get_module(StartPosModule) == null) {
			emitter.add_module(new StartPosModule());
		}
		spos_comps = emitter.components.get(StartPos);

		if(emitter.get_module(VelocityUpdateModule) == null) {
			emitter.add_module(new VelocityUpdateModule());
		}
		vel_comps = emitter.components.get(Velocity);

		for (_ in 0...emitter.particles.capacity) {
			accel_data.push(0);
		}

		particles_data = emitter.particles_data;

	}

	override function spawn(p:Particle) {

		var a:Float = accel;
		if(accel_variance != 0) {
			a += accel_variance * emitter.random_1_to_1();
		}
		accel_data[p.id] = a;

	}

	override function update(dt:Float) {

		var dx:Float;
		var dy:Float;
		var ds:Float;
		var tx:Float;
		var ty:Float;
		var tn:Float;

		var pd:ParticleData;
		var sp:StartPos;
		var v:Velocity;
		var ta:Float;

		for (p in particles) {
			pd = particles_data[p.id];
			sp = spos_comps.get(p);
			v = vel_comps.get(p);
			ta = accel_data[p.id];

			dx = pd.x - sp.x;
			dy = pd.y - sp.y;

			ds = Math.sqrt(dx * dx + dy * dy);
			if (ds < 0.01) {
				ds = 0.01;
			}

			tx = dx / ds;
			ty = dy / ds;

			tn = tx;
			tx = -ty * ta;
			ty = tn * ta;

			v.x += tx * dt;
			v.y += ty * dt;
		}

	}


}


typedef TangentalAccelModuleOptions = {

	@:optional var accel : Float;
	@:optional var accel_variance : Float;
	// @:optional var accel_random : Float;

}


