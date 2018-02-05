package sparkler.modules;

import sparkler.core.Particle;
import sparkler.core.ParticleData;
import sparkler.core.ParticleModule;
import sparkler.core.Components;

import luxe.Vector;

using sparkler.utils.VectorTools;


class AreaSpawnModule  extends ParticleModule {


	public var size(default, null):Vector;
	public var size_max:Vector;
	public var inside:Bool;

	var rnd_point:Vector;


	public function new(_options:AreaSpawnModuleOptions) {

		super(_options);

		size = _options.size != null ? _options.size : new Vector(128, 128);
		size_max = _options.size_max;
		inside = _options.inside != null ? _options.inside : true;

		rnd_point = new Vector();

		priority = -999;
		
	}

	override function onspawn(p:Particle) {

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

	override function onunspawn(p:Particle) {

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


// import/export

	override function from_json(d:Dynamic) {

		super.from_json(d);

		size.from_json(d.size);

		if(d.size_max != null) {
			if(size_max == null) {
				size_max = new Vector();
			}
			size_max.from_json(d.size_max);
		}

		inside = d.inside;

		return this;
	    
	}

	override function to_json():Dynamic {

		var d = super.to_json();

		d.size = size.to_json();

		if(size_max != null) {
			d.size_max = size_max.to_json();
		}

		d.inside = inside;

		return d;
	    
	}


}

typedef AreaSpawnModuleOptions = {

	>ParticleModuleOptions,

	@:optional var size:Vector;
	@:optional var size_max:Vector;
	@:optional var inside:Bool;

}
