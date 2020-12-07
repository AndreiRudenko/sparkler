package sparkler.modules.spawn;

import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Area;

@group('spawn')
class CircleSpawnModule extends ParticleModule<Particle> {

	public var circleSpawn:Float = 32;

	function new(options:{?circleSpawn:Float}) {
		if(options.circleSpawn != null) circleSpawn = options.circleSpawn;
	}

	override function onPreParticleSpawn(p:Particle) {
		var a = random() * Math.PI * 2;
		var r = random() * circleSpawn;
		var px = Math.cos(a) * r;
		var py = Math.sin(a) * r;
		setParticlePos(p, px, py);
	}
	
}