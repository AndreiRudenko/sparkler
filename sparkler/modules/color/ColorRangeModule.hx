package sparkler.modules.color;

import sparkler.utils.Color;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Range;

@priority(5)
@group('color')
class ColorRangeModule extends ParticleModule<Particle<Color>> {

	public var colorRange:Range<Color>;

	function new(options:{?colorRange:{min:sparkler.utils.Color, max:sparkler.utils.Color}}) {
		colorRange = new Range(new Color(), new Color());
		if(options.colorRange != null) {
			colorRange.min = options.colorRange.min;
			colorRange.max = options.colorRange.max;
		}
	}

	inline function randomColor(a:Color, b:Color):Color {
		return Color.lerp(a, b, random());
	}

	override function onParticleSpawn(p:Particle<Color>) {
		p.color = randomColor(colorRange.min, colorRange.max);
	}
	
}