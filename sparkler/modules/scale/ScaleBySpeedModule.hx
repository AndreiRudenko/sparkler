package sparkler.modules.scale;

import sparkler.components.Speed;
import sparkler.components.Scale;
import sparkler.utils.Maths;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.scale.ScaleBySpeedModule.ScaleBySpeed;

class ScaleBySpeed {

	public var ease:(v:Float)->Float;

	public var minScale:Float = 1;
	public var maxScale:Float = 1;

	public var minSpeed:Float = 0;
	public var maxSpeed:Float = 128;

	public function new() {}

}

@priority(100)
@group('scale')
@addModules(sparkler.modules.helpers.UpdateSpeedModule)
class ScaleBySpeedModule extends ParticleModule<Particle<Scale, Speed>> {

	public var scaleBySpeed:ScaleBySpeed;

	function new(options:{
		?scaleBySpeed:{
			minScale:Float,
			maxScale:Float,
			minSpeed:Float,
			maxSpeed:Float,
			?ease:(v:Float)->Float
		}
	}) {
		scaleBySpeed = new ScaleBySpeed();
		if(options.scaleBySpeed != null) {
			scaleBySpeed.minScale = options.scaleBySpeed.minScale;
			scaleBySpeed.maxScale = options.scaleBySpeed.maxScale;
			scaleBySpeed.minSpeed = options.scaleBySpeed.minSpeed;
			scaleBySpeed.maxSpeed = options.scaleBySpeed.maxSpeed;
			scaleBySpeed.ease = options.scaleBySpeed.ease;
		}
	}

	override function onParticleSpawn(p:Particle<Scale, Speed>) {
		p.scale = scaleBySpeed.minScale;
	}
	
	override function onParticleUpdate(p:Particle<Scale, Speed>, elapsed:Float) {
		var scaleSpeedInvLerp = Maths.clamp(Maths.inverseLerp(scaleBySpeed.minSpeed, scaleBySpeed.maxSpeed, p.speed), 0, 1);
		p.scale = Maths.lerp(scaleBySpeed.minScale, scaleBySpeed.maxScale, scaleBySpeed.ease != null ? scaleBySpeed.ease(scaleSpeedInvLerp) : scaleSpeedInvLerp);
	}

}