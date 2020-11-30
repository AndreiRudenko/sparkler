package sparkler.modules.color;

import sparkler.components.Color;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.color.ColorOverLifetimeModule.ColorOverLifetime;

class ColorOverLifetime {

	public var start:Color;
	public var end:Color;
	public var ease:(v:Float)->Float;

	public function new() {}

}

@priority(5)
@group('color')
class ColorOverLifetimeModule extends ParticleModule<Particle<Color>> {

	public var colorOverLifetime:ColorOverLifetime;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?colorOverLifetime:{?ease:(v:Float)->Float, start:sparkler.utils.Color, end:sparkler.utils.Color}}) {
		colorOverLifetime = new ColorOverLifetime();

		if(options.colorOverLifetime != null) {
			colorOverLifetime.start = options.colorOverLifetime.start;
			colorOverLifetime.end = options.colorOverLifetime.end;
			colorOverLifetime.ease = options.colorOverLifetime.ease;
		} else {
			colorOverLifetime.start = new Color();
			colorOverLifetime.end = new Color();
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Color>, elapsed:Float) {
		_lerp = p.age / p.lifetime;
	}

	override function onParticleUpdate(p:Particle<Color>, elapsed:Float) {
		p.color = lerpColor(_lerp);
	}

	override function onParticleSpawn(p:Particle<Color>) {
		p.color = colorOverLifetime.start;
	}

	inline function lerpColor(t:Float):Color {
		if(colorOverLifetime.ease != null) t = colorOverLifetime.ease(t);
		return Color.lerp(colorOverLifetime.start, colorOverLifetime.end, t);
	}
	
}