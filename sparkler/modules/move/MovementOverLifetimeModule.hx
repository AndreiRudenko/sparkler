package sparkler.modules.move;

import sparkler.utils.Vector2;
import sparkler.utils.Maths;
import sparkler.components.Velocity;
import sparkler.components.LifeProgress;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.move.MovementOverLifetimeModule.MovementOverLifetime;


class MovementOverLifetime {

	public var start:Vector2 = new Vector2();
	public var end:Vector2 = new Vector2();
	public var ease:(v:Float)->Float;

	public function new() {}

}

@priority(65)
@group('move')
@addModules(sparkler.modules.helpers.LifeProgressModule)
class MovementOverLifetimeModule extends ParticleModule<Particle<LifeProgress>> {

	public var movementOverLifetime:MovementOverLifetime;

	function new(options:{?movementOverLifetime:{start:{x:Float, y:Float}, end:{x:Float, y:Float}, ease:(v:Float)->Float}}) {
		movementOverLifetime = new MovementOverLifetime();
		if(options.movementOverLifetime != null) {
			movementOverLifetime.start.x = options.movementOverLifetime.start.x;
			movementOverLifetime.start.y = options.movementOverLifetime.start.y;
			movementOverLifetime.end.x = options.movementOverLifetime.end.x;
			movementOverLifetime.end.y = options.movementOverLifetime.end.y;
			movementOverLifetime.ease = options.movementOverLifetime.ease;
		}
	}

	override function onParticleUpdate(p:Particle<LifeProgress>, elapsed:Float) {
		var t = movementOverLifetime.ease != null ? movementOverLifetime.ease(p.lifeProgress) : p.lifeProgress;
		p.x += Maths.lerp(movementOverLifetime.start.x, movementOverLifetime.end.x, t) * elapsed;
		p.y += Maths.lerp(movementOverLifetime.start.y, movementOverLifetime.end.y, t) * elapsed;
	}

}