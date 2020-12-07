package sparkler.modules.spawn;

import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Area;

@group('spawn')
class AreaSpawnModule extends ParticleModule<Particle> {

	public var areaSpawn:Area;

	function new(options:{?areaSpawn:{width:Float, height:Float}}) {
		areaSpawn = new Area(0, 0);
		if(options.areaSpawn != null) {
			areaSpawn.width = options.areaSpawn.width;
			areaSpawn.height = options.areaSpawn.height;
		}
	}

	override function onPreParticleSpawn(p:Particle) {
		var px = areaSpawn.width * 0.5 * random1To1();
		var py = areaSpawn.height * 0.5 * random1To1();
		setParticlePos(p, px, py);
	}
	
}