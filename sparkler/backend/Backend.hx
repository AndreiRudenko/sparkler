package sparkler.backend;

import sparkler.core.ParticleData;
import sparkler.core.Particle;

interface Backend {

	function sprite_create(p:Particle):ParticleData;
	function sprite_destroy(pd:ParticleData):Void;
	function sprite_show(pd:ParticleData):Void;
	function sprite_hide(pd:ParticleData):Void;
	function sprite_update(pd:ParticleData):Void;
	function sprite_set_depth(pd:ParticleData,depth:Float):Void;
	function sprite_set_texture(pd:ParticleData,path:String):Void;

}

