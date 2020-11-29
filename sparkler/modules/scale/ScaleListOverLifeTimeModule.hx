package sparkler.modules.scale;

import sparkler.components.ScalePropertyList;
import sparkler.components.Scale;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(3)
@group('scale')
class ScaleListOverLifeTimeModule extends ParticleModule<Particle<Scale, ScalePropertyList>> {

	public var scaleListOverLifeTime:ScalePropertyList;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?scaleListOverLifeTime:{?ease:(v:Float)->Float, list:Array<{time:Float, value:Float}>}}) {
		if(options.scaleListOverLifeTime != null) {
			scaleListOverLifeTime = ScalePropertyList.create(options.scaleListOverLifeTime.list);
			scaleListOverLifeTime.ease = options.scaleListOverLifeTime.ease;
		} else {
			scaleListOverLifeTime = new ScalePropertyList();
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Scale, ScalePropertyList>, elapsed:Float) {
		_lerp = p.age / p.lifeTime;
	}

	override function onParticleUpdate(p:Particle<Scale, ScalePropertyList>, elapsed:Float) {
		p.scalePropertyList.interpolate(_lerp);
		p.scale = p.scalePropertyList.value;
	}
	override function onParticleSpawn(p:Particle<Scale, ScalePropertyList>) {
		p.scalePropertyList.set(scaleListOverLifeTime);
		p.scale = p.scalePropertyList.value;
	}
	
}