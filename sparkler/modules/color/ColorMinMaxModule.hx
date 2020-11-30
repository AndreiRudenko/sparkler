package sparkler.modules.color;

import sparkler.utils.Color;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Bounds;

@priority(5)
@group('color')
class ColorMinMaxModule extends ParticleModule<Particle<Color>> {

	public var colorMinMax:Bounds<Color>;

	function new(options:{?colorMinMax:{min:sparkler.utils.Color, max:sparkler.utils.Color}}) {
		colorMinMax = new Bounds(new Color(), new Color());
		if(options.colorMinMax != null) {
			colorMinMax.min = options.colorMinMax.min;
			colorMinMax.max = options.colorMinMax.max;
		}
	}

	inline function randomColor(a:Color, b:Color):Color {
		return Color.lerp(a, b, random());
	}

	override function onParticleSpawn(p:Particle<Color>) {
		p.color = randomColor(colorMinMax.min, colorMinMax.max);
	}
	
}



// ColorModule
// ColorOverLifetimeModule

// ColorMinMaxModule
// ColorMinMaxOverLifetimeModule

// ColorListOverLifetimeModule
// ColorMinMaxListOverLifetimeModule


// VelocityModule
// VelocityOverLifetimeModule

// VelocityMinMaxModule
// VelocityMinMaxOverLifetimeModule

// VelocityListOverLifetimeModule
// VelocityMinMaxListOverLifetimeModule


// ScaleModule
// ScaleOverLifetimeModule

// ScaleMinMaxModule
// ScaleMinMaxOverLifetimeModule

// ScaleListOverLifetimeModule
// ScaleMinMaxListOverLifetimeModule


// LifetimeModule
// LifetimeOverEmitterLifeModule

// LifetimeMinMaxModule
// LifetimeMinMaxOverEmitterLifeModule

// LifetimeListOverEmitterLifeModule
// LifetimeMinMaxListOverEmitterLifeModule
