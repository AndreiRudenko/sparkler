package sparkler.render.kha;


import kha.graphics2.Graphics;
import kha.Framebuffer;
import sparkler.ParticleEmitter;


class KhaRenderer extends Renderer {


	override function get(emitter:ParticleEmitter):EmitterRenderer {

		return new KhaEmitter(this, emitter);

	}

}
