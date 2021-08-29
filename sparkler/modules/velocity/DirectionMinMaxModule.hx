package sparkler.modules.velocity;

import sparkler.utils.Vector2;
import sparkler.utils.Maths;
import sparkler.utils.Bounds;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.velocity.DirectionMinMaxModule.DirectionMinMax;

class DirectionMinMax {

	public var angle:Bounds<Float> = new Bounds(0.0, 0.0);
	public var speed:Bounds<Float> = new Bounds(64.0, 128.0);

	public function new() {}

}

@priority(10)
@group('velocity')
@addModules(sparkler.modules.helpers.UpdatePosFromVelocityModule)
class DirectionMinMaxModule extends ParticleModule<Particle<Velocity>> {

	public var directionMinMax:DirectionMinMax;

	function new(options:{?directionMinMax:{angle:{min:Float, max:Float}, speed:{min:Float, max:Float}}}) {
		directionMinMax = new DirectionMinMax();
		if(options.directionMinMax != null) {
			directionMinMax.angle.min = options.directionMinMax.angle.min;
			directionMinMax.angle.max = options.directionMinMax.angle.max;
			directionMinMax.speed.min = options.directionMinMax.speed.min;
			directionMinMax.speed.max = options.directionMinMax.speed.max;
		}
	}

	override function onParticleSpawn(p:Particle<Velocity>) {
		var dAngle:Float = Maths.radians(randomFloat(directionMinMax.angle.min, directionMinMax.angle.max));
		var dSpeed:Float = randomFloat(directionMinMax.speed.min, directionMinMax.speed.max);
		if(!localSpace) dAngle += _rotation;
		
		p.velocity.x = dSpeed * Math.cos(dAngle);
		p.velocity.y = dSpeed * Math.sin(dAngle);
	}

}