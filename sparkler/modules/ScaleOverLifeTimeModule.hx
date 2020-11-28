package sparkler.modules;

import sparkler.components.ScalePropertyList;
// import sparkler.utils.FloatPropertyList;
import sparkler.components.Scale;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(3)
@group('scale')
class ScaleOverLifeTimeModule extends ParticleModule<Particle<Scale, ScalePropertyList>> {

	public var scaleOverLifeTime:ScalePropertyList;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?scaleOverLifeTime:{?ease:(v:Float)->Float, list:Array<{time:Float, value:Float}>}}) {
		if(options.scaleOverLifeTime != null) {
			scaleOverLifeTime = ScalePropertyList.create(options.scaleOverLifeTime.list);
			scaleOverLifeTime.ease = options.scaleOverLifeTime.ease;
		} else {
			scaleOverLifeTime = new ScalePropertyList();
		}
	}

	@filter('_lerp')
	override function onPreParticleUpdate(p:Particle<Scale, ScalePropertyList>, elapsed:Float) {
		_lerp = p.age / p.lifetime;
	}

	override function onParticleUpdate(p:Particle<Scale, ScalePropertyList>, elapsed:Float) {
		p.scalePropertyList.interpolate(_lerp);
		p.scale = p.scalePropertyList.value;
	}
	override function onParticleSpawn(p:Particle<Scale, ScalePropertyList>) {
		p.scalePropertyList.set(scaleOverLifeTime);
		p.scale = p.scalePropertyList.value;
	}
	
}