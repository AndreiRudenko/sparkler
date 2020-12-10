package sparkler.modules.color;

import sparkler.components.Speed;
import sparkler.utils.Color;
import sparkler.utils.Maths;
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
		var colorSpeedInvLerp = Maths.clamp(Maths.inverseLerp(colorBySpeed.minSpeed, colorBySpeed.maxSpeed, p.speed), 0, 1);
		p.color = Color.lerp(colorBySpeed.minColor, colorBySpeed.maxColor, colorBySpeed.ease != null ? colorBySpeed.ease(colorSpeedInvLerp) : colorSpeedInvLerp);
	}

}