package sparkler.modules.color;

import sparkler.components.Color;
import sparkler.components.ColorRange;
import sparkler.utils.Bounds;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.color.ColorMinMaxOverLifetimeModule.ColorMinMaxOverLifetime;

class ColorMinMaxOverLifetime {

	public var start:Bounds<Color>;
	public var end:Bounds<Color>;
	public var ease:(v:Float)->Float;

	public function new() {
		start = new Bounds<Color>(-1,-1);
		end = new Bounds<Color>(-1,-1);
	}

}

@priority(5)
@group('color')
class ColorMinMaxOverLifetimeModule extends ParticleModule<Particle<Color, ColorRange>> {

	public var colorMinMaxOverLifetime:ColorMinMaxOverLifetime;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(
		options:{
			?colorMinMaxOverLifetime:{
				?ease:(v:Float)->Float, 
				start:{min:sparkler.utils.Color, max:sparkler.utils.Color}, 
				end:{min:sparkler.utils.Color, max:sparkler.utils.Color}
			}
		}
	) {
		colorMinMaxOverLifetime = new ColorMinMaxOverLifetime();

		if(options.colorMinMaxOverLifetime != null) {
			colorMinMaxOverLifetime.start.min = options.colorMinMaxOverLifetime.start.min;
			colorMinMaxOverLifetime.start.max = options.colorMinMaxOverLifetime.start.max;
			colorMinMaxOverLifetime.end.min = options.colorMinMaxOverLifetime.end.min;
			colorMinMaxOverLifetime.end.max = options.colorMinMaxOverLifetime.end.max;
			colorMinMaxOverLifetime.ease = options.colorMinMaxOverLifetime.ease;
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Color, ColorRange>, elapsed:Float) {
		_lerp = p.age / p.lifetime;
	}

	override function onParticleUpdate(p:Particle<Color, ColorRange>, elapsed:Float) {
		p.color = lerpColor(p.colorRange.start, p.colorRange.end, _lerp);
	}

	override function onParticleSpawn(p:Particle<Color, ColorRange>) {
		p.colorRange.start = randomColor(colorMinMaxOverLifetime.start.min, colorMinMaxOverLifetime.start.max);
		p.colorRange.end = randomColor(colorMinMaxOverLifetime.end.min, colorMinMaxOverLifetime.end.max);
		p.color = p.colorRange.start;
	}

	inline function lerpColor(start:Color, end:Color, t:Float):Color {
		if(colorMinMaxOverLifetime.ease != null) t = colorMinMaxOverLifetime.ease(t);
		return Color.lerp(start, end, t);
	}
	
	inline function randomColor(a:Color, b:Color):Color {
		return Color.lerp(a, b, random());
	}
	
}