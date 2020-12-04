package sparkler.modules.rotate;

import sparkler.utils.Vector2;
import sparkler.components.AngularVelocity;
import sparkler.components.Rotation;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(10)
@group('angularVelocity')
class AngularVelocityModule extends ParticleModule<Particle<AngularVelocity, Rotation>> {

	public var angularVelocity:Float = 90;

	function new(options:{?angularVelocity:Float}) {
		if(options.angularVelocity != null) angularVelocity = options.angularVelocity;
	}

	override function onParticleSpawn(p:Particle<AngularVelocity, Rotation>) {
		p.angularVelocity = angularVelocity;
	}

	override function onParticleUnspawn(p:Particle<AngularVelocity, Rotation>) {
		p.rotation = 0;
	}

	@filter('angularVelocity')
	override function onPostParticleUpdate(p:Particle<AngularVelocity, Rotation>, elapsed:Float) {
		p.rotation += p.angularVelocity * elapsed;
	}

}