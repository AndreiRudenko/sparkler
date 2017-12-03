package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.ParticleData;
import particles.core.Components;
import particles.components.Life;

import luxe.Color;


class ColorLifeModule extends ParticleModule {


	public var initial_color	(default, null):Color;
	public var end_color    	(default, null):Color;
	public var initial_color_max:Color;
	public var end_color_max:Color;

	var color_delta:Array<Color>;
	var particles_data:Array<ParticleData>;
	var life:Components<Life>;


	public function new(_options:ColorLifeModuleOptions) {

		super();

		color_delta = [];

		initial_color = _options.initial_color != null ? _options.initial_color : new Color();
		initial_color_max = _options.initial_color_max;
		end_color = _options.end_color != null ? _options.end_color : new Color();
		end_color_max = _options.end_color_max;

	}

	override function init() {

		particles_data = emitter.particles_data;

		life = emitter.components.get(Life);
		if(life == null) {
			throw('LifeTimeModule is required for ScaleModule');
		}

		for (i in 0...particles.capacity) {
			color_delta[i] = new Color();
		}
	    
	}

	override function spawn(p:Particle) {

		var cd:Color = color_delta[p.id];
		var lf:Float = life.get(p).amount;
		var pcolor:Color = particles_data[p.id].sprite.color;

		if(initial_color_max != null) {
			pcolor.r = emitter.random_float(initial_color.r, initial_color_max.r);
			pcolor.g = emitter.random_float(initial_color.g, initial_color_max.g);
			pcolor.b = emitter.random_float(initial_color.b, initial_color_max.b);
			pcolor.a = emitter.random_float(initial_color.a, initial_color_max.a);
		} else {
			pcolor.r = initial_color.r;
			pcolor.g = initial_color.g;
			pcolor.b = initial_color.b;
			pcolor.a = initial_color.a;
		}
		
		if(end_color_max != null) {
			cd.r = emitter.random_float(end_color.r, end_color_max.r) - pcolor.r;
			cd.g = emitter.random_float(end_color.g, end_color_max.g) - pcolor.g;
			cd.b = emitter.random_float(end_color.b, end_color_max.b) - pcolor.b;
			cd.a = emitter.random_float(end_color.a, end_color_max.a) - pcolor.a;
		} else {
			cd.r = end_color.r - pcolor.r;
			cd.g = end_color.g - pcolor.g;
			cd.b = end_color.b - pcolor.b;
			cd.a = end_color.a - pcolor.a;
		}

		if(cd.r != 0) { cd.r /= lf; }
		if(cd.g != 0) { cd.g /= lf; }
		if(cd.b != 0) { cd.b /= lf; }
		if(cd.a != 0) { cd.a /= lf; }

	}

	override function update(dt:Float) {

		var cd:Color;
		var pcolor:Color;
		for (p in particles) {
			cd = color_delta[p.id];
			pcolor = particles_data[p.id].sprite.color;
			pcolor.r += cd.r * dt;
			pcolor.g += cd.g * dt;
			pcolor.b += cd.b * dt;
			pcolor.a += cd.a * dt;
		}

	}
	

}


typedef ColorLifeModuleOptions = {
	
	@:optional var initial_color : Color;
	@:optional var initial_color_max : Color;
	@:optional var end_color : Color;
	@:optional var end_color_max : Color;

}


