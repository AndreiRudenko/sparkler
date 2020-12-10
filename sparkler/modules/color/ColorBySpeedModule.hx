package sparkler.modules.color;

import sparkler.components.Speed;
import sparkler.utils.Color;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.color.ColorBySpeedModule.ColorBySpeed;

class ColorBySpeed {

	public var ease:(v:Float)->Float;

	public var minColor:Color = new Color();
	public var maxColor:Color = new Color();

	public var minSpeed:Float = 0;
	public var maxSpeed:Float = 128;

	public function new() {}

}

@priority(80) // after speed set by prev and current position
@group('color')
@addModules(sparkler.modules.helpers.UpdateSpeedModule)
class ColorBySpeedModule extends ParticleModule<Particle<Color, Speed>> {

	public var colorBySpeed:ColorBySpeed;

	function new(options:{
		?colorBySpeed:{
			minColor:sparkler.utils.Color,
			maxColor:sparkler.utils.Color,
			minSpeed:Float,
			maxSpeed:Float,
			?ease:(v:Float)->Float
		}
	}) {
		colorBySpeed = new ColorBySpeed();
		if(options.colorBySpeed != null) {
			colorBySpeed.minColor = options.colorBySpeed.minColor;
			colorBySpeed.maxColor = options.colorBySpeed.maxColor;
			colorBySpeed.minSpeed = options.colorBySpeed.minSpeed;
			colorBySpeed.maxSpeed = options.colorBySpeed.maxSpeed;
			colorBySpeed.ease = options.colorBySpeed.ease;
		}
	}

	override function onParticleSpawn(p:Particle<Color, Speed>) {
		p.color = colorBySpeed.minColor;
	}
	
	override function onPostParticleUpdate(p:Particle<Color, Speed>, elapsed:Float) {
		var colorSpeedInvLerp = (p.speed - colorBySpeed.minSpeed) / (colorBySpeed.maxSpeed - colorBySpeed.minSpeed);

		if(colorSpeedInvLerp < 0) {
			colorSpeedInvLerp = 0;
		} else if(colorSpeedInvLerp > 1) {
			colorSpeedInvLerp = 1;
		}

		p.color = lerpColor(colorSpeedInvLerp);
	}


	inline function lerpColor(t:Float):Color {
		if(colorBySpeed.ease != null) t = colorBySpeed.ease(t);
		return Color.lerp(colorBySpeed.minColor, colorBySpeed.maxColor, t);
	}

}