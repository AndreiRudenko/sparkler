package sparkler.modules.velocity;

import sparkler.utils.Vector2;
import sparkler.utils.Maths;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.velocity.DirectionModule.Direction;

class Direction {

	public var angle:Float = 0;
	public var speed:Float = 128;

	public function new() {}

}

@priority(10)
@group('velocity')
@addModules(sparkler.modules.helpers.UpdatePosFromVelocityModule)
class DirectionModule extends ParticleModule<Particle<Velocity>> {

	public var direction:Direction;

	function new(options:{?direction:{angle:Float, speed:Float}}) {
		direction = new Direction();
		if(options.direction != null) {
			direction.angle = options.direction.angle;
			direction.speed = options.direction.speed;
		}
	}

	override function onParticleSpawn(p:Particle<Velocity>) {
		var angle:Float = Maths.radians(direction.angle);
		
		if(!localSpace) angle += rotation;
		
		p.velocity.x = direction.speed * Math.cos(angle);
		p.velocity.y = direction.speed * Math.sin(angle);
	}

}