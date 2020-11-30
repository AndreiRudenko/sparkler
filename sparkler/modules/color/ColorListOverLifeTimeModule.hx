package sparkler.modules.color;

import sparkler.components.ColorPropertyList;
import sparkler.components.Color;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(5)
@group('color')
class ColorListOverLifetimeModule extends ParticleModule<Particle<Color, ColorPropertyList>> {

	public var colorListOverLifetime:ColorPropertyList;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?colorListOverLifetime:{?ease:(v:Float)->Float, list:Array<{time:Float, value:sparkler.utils.Color}>}}) {
		if(options.colorListOverLifetime != null) {
			colorListOverLifetime = ColorPropertyList.create(options.colorListOverLifetime.list);
			colorListOverLifetime.ease = options.colorListOverLifetime.ease;
		} else {
			colorListOverLifetime = new ColorPropertyList();
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
		p.colorPropertyList.set(colorListOverLifetime);
		p.color = p.colorPropertyList.value;
	}
	
}