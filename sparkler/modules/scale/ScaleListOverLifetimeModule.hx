package sparkler.modules.scale;

import sparkler.components.LifeProgress;
import sparkler.components.ScalePropertyList;
import sparkler.components.Scale;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(3)
@group('scale')
@addModules(sparkler.modules.life.LifeProgressModule)
class ScaleListOverLifetimeModule extends ParticleModule<Particle<Scale, ScalePropertyList, LifeProgress>> {

	public var scaleListOverLifetime:ScalePropertyList;

	function new(options:{?scaleListOverLifetime:{?ease:(v:Float)->Float, list:Array<{time:Float, value:Float}>}}) {
		if(options.scaleListOverLifetime != null) {
			scaleListOverLifetime = ScalePropertyList.create(options.scaleListOverLifetime.list);
			scaleListOverLifetime.ease = options.scaleListOverLifetime.ease;
		} else {
			scaleListOverLifetime = new ScalePropertyList();
		}
	}

	override function onParticleUpdate(p:Particle<Scale, ScalePropertyList, LifeProgress>, elapsed:Float) {
		p.scalePropertyList.interpolate(p.lifeProgress);
		p.scale = p.scalePropertyList.value;
	}
	override function onParticleSpawn(p:Particle<Scale, ScalePropertyList, LifeProgress>) {
		p.scalePropertyList.set(scaleListOverLifetime);
		p.scale = p.scalePropertyList.value;
	}
	
}