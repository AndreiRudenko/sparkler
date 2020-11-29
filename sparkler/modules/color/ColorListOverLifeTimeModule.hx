package sparkler.modules.color;

import sparkler.components.ColorPropertyList;
import sparkler.components.Color;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(5)
@group('color')
class ColorListOverLifeTimeModule extends ParticleModule<Particle<Color, ColorPropertyList>> {

	public var colorListOverLifeTime:ColorPropertyList;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?colorListOverLifeTime:{?ease:(v:Float)->Float, list:Array<{time:Float, value:sparkler.utils.Color}>}}) {
		if(options.colorListOverLifeTime != null) {
			colorListOverLifeTime = ColorPropertyList.create(options.colorListOverLifeTime.list);
			colorListOverLifeTime.ease = options.colorListOverLifeTime.ease;
		} else {
			colorListOverLifeTime = new ColorPropertyList();
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Color, ColorPropertyList>, elapsed:Float) {
		_lerp = p.age / p.lifeTime;
	}

	override function onParticleUpdate(p:Particle<Color, ColorPropertyList>, elapsed:Float) {
		p.colorPropertyList.interpolate(_lerp);
		p.color = p.colorPropertyList.value;
	}
	override function onParticleSpawn(p:Particle<Color, ColorPropertyList>) {
		p.colorPropertyList.set(colorListOverLifeTime);
		p.color = p.colorPropertyList.value;
	}
	
}