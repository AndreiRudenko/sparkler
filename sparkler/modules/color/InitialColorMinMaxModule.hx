package sparkler.modules.color;

import sparkler.utils.Color;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Bounds;

@priority(5)
@group('color')
class InitialColorMinMaxModule extends ParticleModule<Particle<Color>> {

	public var initialColorMinMax:Bounds<Color>;

	function new(options:{?initialColorMinMax:{min:sparkler.utils.Color, max:sparkler.utils.Color}}) {
		initialColorMinMax = new Bounds(new Color(), new Color());
		if(options.initialColorMinMax != null) {
			initialColorMinMax.min = options.initialColorMinMax.min;
			initialColorMinMax.max = options.initialColorMinMax.max;
		}
	}

	inline function randomColor(a:Color, b:Color):Color {
		return Color.lerp(a, b, random());
	}

	override function onParticleSpawn(p:Particle<Color>) {
		p.color = randomColor(initialColorMinMax.min, initialColorMinMax.max);
	}
	
}