package sparkler.modules.scale;

import sparkler.components.ScalePropertyList;
import sparkler.components.Scale;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(3)
@group('scale')
class ScaleListOverLifetimeModule extends ParticleModule<Particle<Scale, ScalePropertyList>> {

	public var scaleListOverLifetime:ScalePropertyList;

	@filter('_lerp')
	var _lerp:Float = 0;

	function new(options:{?scaleListOverLifetime:{?ease:(v:Float)->Float, list:Array<{time:Float, value:Float}>}}) {
		if(options.scaleListOverLifetime != null) {
			scaleListOverLifetime = ScalePropertyList.create(options.scaleListOverLifetime.list);
			scaleListOverLifetime.ease = options.scaleListOverLifetime.ease;
		} else {
			scaleListOverLifetime = new ScalePropertyList();
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
		p.scalePropertyList.set(scaleListOverLifetime);
		p.scale = p.scalePropertyList.value;
	}
	
}