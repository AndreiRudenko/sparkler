package sparkler.modules.color;

import sparkler.components.Color;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.color.ColorOverLifeTimeModule.ColorOverLifeTime;

class ColorOverLifeTime {

	public var start:Color;
	public var end:Color;
	public var ease:(v:Float)->Float;

	public function new() {}

}

@priority(5)
@group('color')
class ColorOverLifeTimeModule extends ParticleModule<Particle<Color>> {

	public var colorOverLifeTime:ColorOverLifeTime;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?colorOverLifeTime:{?ease:(v:Float)->Float, start:sparkler.utils.Color, end:sparkler.utils.Color}}) {
		colorOverLifeTime = new ColorOverLifeTime();

		if(options.colorOverLifeTime != null) {
			colorOverLifeTime.start = options.colorOverLifeTime.start;
			colorOverLifeTime.end = options.colorOverLifeTime.end;
			colorOverLifeTime.ease = options.colorOverLifeTime.ease;
		} else {
			colorOverLifeTime.start = new Color();
			colorOverLifeTime.end = new Color();
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Color>, elapsed:Float) {
		_lerp = p.age / p.lifeTime;
	}

	override function onParticleUpdate(p:Particle<Color>, elapsed:Float) {
		p.color = interpolate(_lerp);
	}

	override function onParticleSpawn(p:Particle<Color>) {
		p.color = colorOverLifeTime.start;
	}

	inline function interpolate(t:Float):Color {
		if(colorOverLifeTime.ease != null) t = colorOverLifeTime.ease(t);
		return Color.lerp(colorOverLifeTime.start, colorOverLifeTime.end, t);
	}
	
}