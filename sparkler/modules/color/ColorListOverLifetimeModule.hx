package sparkler.modules.color;

import sparkler.components.ColorPropertyList;
import sparkler.components.LifeProgress;
import sparkler.components.Color;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(5)
@group('color')
@addModules(sparkler.modules.life.LifeProgressModule)
class ColorListOverLifetimeModule extends ParticleModule<Particle<Color, ColorPropertyList, LifeProgress>> {

	public var colorListOverLifetime:ColorPropertyList;

	function new(options:{?colorListOverLifetime:{?ease:(v:Float)->Float, list:Array<{time:Float, value:sparkler.utils.Color}>}}) {
		if(options.colorListOverLifetime != null) {
			colorListOverLifetime = ColorPropertyList.create(options.colorListOverLifetime.list);
			colorListOverLifetime.ease = options.colorListOverLifetime.ease;
		} else {
			colorListOverLifetime = new ColorPropertyList();
		}
	}

	override function onParticleUpdate(p:Particle<Color, ColorPropertyList, LifeProgress>, elapsed:Float) {
		p.colorPropertyList.interpolate(p.lifeProgress);
		p.color = p.colorPropertyList.value;
	}
	override function onParticleSpawn(p:Particle<Color, ColorPropertyList, LifeProgress>) {
		p.colorPropertyList.set(colorListOverLifetime);
		p.color = p.colorPropertyList.value;
	}
	
}