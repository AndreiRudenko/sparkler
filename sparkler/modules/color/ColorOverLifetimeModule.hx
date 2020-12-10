package sparkler.modules.color;

import sparkler.components.Color;
import sparkler.components.LifeProgress;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.color.ColorOverLifetimeModule.ColorOverLifetime;

class ColorOverLifetime {

	public var start:Color;
	public var end:Color;
	public var ease:(v:Float)->Float;

	public function new() {}

}

@priority(80)
@group('color')
@addModules(sparkler.modules.helpers.LifeProgressModule)
class ColorOverLifetimeModule extends ParticleModule<Particle<Color, LifeProgress>> {

	public var colorOverLifetime:ColorOverLifetime;

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

	override function onParticleUpdate(p:Particle<Color, LifeProgress>, elapsed:Float) {
		p.color = Color.lerp(colorOverLifetime.start, colorOverLifetime.end, colorOverLifetime.ease != null ? colorOverLifetime.ease(p.lifeProgress) : p.lifeProgress);
	}

	override function onParticleSpawn(p:Particle<Color, LifeProgress>) {
		p.color = colorOverLifetime.start;
	}

}