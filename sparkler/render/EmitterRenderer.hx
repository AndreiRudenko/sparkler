package sparkler.render;


import sparkler.ParticleEmitter;
import sparkler.core.ParticleData;
import sparkler.core.Particle;
import sparkler.data.BlendMode;


class EmitterRenderer {


	var emitter:ParticleEmitter;


	public function new(_emitter:ParticleEmitter) {

		emitter = _emitter;

	}

	public function init() {}
	public function destroy() {}

	public function onparticleshow(p:Particle) {}
	public function onparticlehide(p:Particle) {}

	public function ontexture(path:String) {}
	public function update(dt:Float) {}

	public function ondepth(v:Float) {}
	public function onlayer(v:Int) {}

	public function onblendsrc(v:BlendMode) {}
	public function onblenddest(v:BlendMode) {}

	#if kha
	public function render(c:kha.Canvas) {}
	#end
	

}