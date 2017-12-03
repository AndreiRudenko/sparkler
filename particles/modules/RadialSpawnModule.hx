package particles.modules;

import particles.core.Particle;
import particles.core.ParticleData;
import particles.core.ParticleModule;

import luxe.Vector;


class RadialSpawnModule  extends ParticleModule {


	public var radius:Float;
	public var radius_max:Float;
	public var inside:Bool;

	var rnd_point:Vector;


	public function new(_options:RadialSpawnModuleOptions) {

		super();

		radius = _options.radius != null ? _options.radius : 128;
		radius_max = _options.radius_max != null ? _options.radius_max : 0;
		inside = _options.inside != null ? _options.inside : true;

		rnd_point = new Vector();

		priority = -999;
		override_priority = true;
		
	}

	override function spawn(p:Particle) {

		var pd:ParticleData = emitter.add_to_bacher(p);

		random_point_in_unit_circle();

		if(!inside) {
			rnd_point.normalize();
		}

		var r:Float = radius;

		if(radius_max != 0) {
			r = emitter.random_float(radius, radius_max);
		}

		pd.x = emitter.system.position.x + emitter.position.x + rnd_point.x * r;
		pd.y = emitter.system.position.y + emitter.position.y + rnd_point.y * r;

	}

	override function unspawn(p:Particle) {

		emitter.remove_from_bacher(p);

	}

	inline function random_point_in_unit_circle() : Vector {

		var _r:Float = Math.sqrt( emitter.random() );
		var _t:Float = (-1 + (2 * emitter.random())) * 6.283185307179586; // two PI

		rnd_point.set_xy( (_r * Math.cos(_t)), (_r * Math.sin(_t)) );

		return rnd_point;

	}

}


typedef RadialSpawnModuleOptions = {

	@:optional var radius:Float;
	@:optional var radius_max:Float;
	@:optional var inside:Bool;

}


