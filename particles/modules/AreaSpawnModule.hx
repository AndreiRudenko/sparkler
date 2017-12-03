package particles.modules;

import particles.core.Particle;
import particles.core.ParticleData;
import particles.core.ParticleModule;
import particles.core.Components;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import phoenix.Texture;
import phoenix.Batcher;


class AreaSpawnModule  extends ParticleModule {


	public var size(default, null):Vector;
	public var size_max:Vector;
	public var inside:Bool;

	var rnd_point:Vector;


	public function new(_options:AreaSpawnModuleOptions) {

		super();

		size = _options.size != null ? _options.size : new Vector(128, 128);
		size_max = _options.size_max;
		inside = _options.inside != null ? _options.inside : true;

		rnd_point = new Vector();

		priority = -999;
		override_priority = true;
		
	}

	override function spawn(p:Particle) {

		var pd:ParticleData = emitter.add_to_bacher(p);

		var sx:Float = size.x;
		var sy:Float = size.y;

		if(size_max != null) {
			sx = emitter.random_float(size.x, size_max.x);
			sy = emitter.random_float(size.y, size_max.y);
		}

		if(inside) {
			pd.x = emitter.system.position.x + emitter.position.x + (sx * 0.5 * emitter.random_1_to_1());
			pd.y = emitter.system.position.y + emitter.position.y + (sy * 0.5 * emitter.random_1_to_1());
		} else {
			random_point_on_rect_edge(sx, sy);
			rnd_point.x -= sx * 0.5;
			rnd_point.y -= sy * 0.5;
			pd.x = emitter.system.position.x + emitter.position.x + rnd_point.x;
			pd.y = emitter.system.position.y + emitter.position.y + rnd_point.y;
		}

	}

	override function unspawn(p:Particle) {

		emitter.remove_from_bacher(p);

	}

	inline function random_point_on_rect_edge(width:Float, height:Float) : Vector {

		var rnd_edge_len = emitter.random() * (width * 2 + height * 2);

		if (rnd_edge_len < height){

			rnd_point.x = 0;
			rnd_point.y = height - rnd_edge_len;
			
		} else if (rnd_edge_len < (height + width)){

			rnd_point.x = rnd_edge_len - height;
			rnd_point.y = 0;

		} else if (rnd_edge_len < (height * 2 + width)){

			rnd_point.x = width;
			rnd_point.y = rnd_edge_len - (width + height);

		} else {

			rnd_point.x = width - (rnd_edge_len - (height * 2 + width));
			rnd_point.y = height;

		}

		return rnd_point;

	}

}


typedef AreaSpawnModuleOptions = {

	@:optional var size:Vector;
	@:optional var size_max:Vector;
	@:optional var inside:Bool;

}


