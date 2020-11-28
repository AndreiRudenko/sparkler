package sparkler.modules;

import sparkler.components.ColorPropertyList;
import sparkler.components.Color;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(5)
@group('color')
class ColorOverLifeTimeModule extends ParticleModule<Particle<Color, ColorPropertyList>> {

	public var colorOverLifeTime:ColorPropertyList;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?colorOverLifeTime:{?ease:(v:Float)->Float, list:Array<{time:Float, value:sparkler.utils.Color}>}}) {
		if(options.colorOverLifeTime != null) {
			colorOverLifeTime = ColorPropertyList.create(options.colorOverLifeTime.list);
			colorOverLifeTime.ease = options.colorOverLifeTime.ease;
		} else {
			colorOverLifeTime = new ColorPropertyList();
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Color, ColorPropertyList>, elapsed:Float) {
		_lerp = p.age / p.lifetime;
	}

	override function onParticleUpdate(p:Particle<Color, ColorPropertyList>, elapsed:Float) {
		p.colorPropertyList.interpolate(_lerp);
		p.color = p.colorPropertyList.value;
	}
	override function onParticleSpawn(p:Particle<Color, ColorPropertyList>) {
		p.colorPropertyList.set(colorOverLifeTime);
		p.color = p.colorPropertyList.value;
	}
	
}