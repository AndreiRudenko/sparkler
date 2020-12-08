package sparkler.modules.velocity;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(19) // after all velocity changes
@group('drag')
class DragModule extends ParticleModule<Particle<Velocity>> {

	public var drag:Float = 0;

	function new(options:{?drag:Float}) {
		if(options.drag != null) drag = options.drag;
	}

	override function onPostParticleUpdate(p:Particle<Velocity>, elapsed:Float) {
		var d = 1 / (1 + (elapsed * drag));
		p.velocity.x *= d;
		p.velocity.y *= d;
	}
	
}