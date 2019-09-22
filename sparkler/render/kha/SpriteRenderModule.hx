package sparkler.render.kha;

import sparkler.core.ParticleModule;
import sparkler.core.Particle;
import sparkler.core.Components;
import sparkler.components.Size;
import sparkler.components.Scale;
import sparkler.components.Rotation;
import sparkler.components.Origin;
import sparkler.components.Region;
import sparkler.utils.Mathf;
import sparkler.data.Vector;
import sparkler.data.Color;
import sparkler.data.Rectangle;
import kha.Image;
import kha.graphics4.BlendingFactor;
import kha.graphics4.BlendingOperation;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;


class SpriteRenderModule extends ParticleModule {


	public static var pipeline:PipelineState;

	public var texture(default, set):Image;
	public var region(default, set):Rectangle;

	public var blendMode(default, set):BlendMode;
	public var premultipliedAlpha(get, set):Bool;

	var _blendSrc:BlendingFactor;
	var _blendDst:BlendingFactor;
	var _blendOp:BlendingOperation;
	// var _alphaBlendSrc:BlendingFactor;
	// var _alphaBlendDst:BlendingFactor;
	// var _alphaBlendOp:BlendingOperation;

	var _premultipliedAlpha:Bool;

	var _regionScaled:Rectangle;
	var _regionTmp:Rectangle;
	var _count:Int;

	var _size:Components<Size>;
	var _scale:Components<Scale>;
	var _color:Components<Color>;
	var _rotation:Components<Rotation>;
	var _origin:Components<Origin>;
	var _region:Components<Region>;

	var _sizeDefault:Size;
	var _scaleDefault:Scale;
	var _colorDefault:Color;
	var _rotationDefault:Rotation;
	var _originDefault:Origin;
	
	var _pSortTmp:haxe.ds.Vector<ParticleSprite>;
	var _particleSprites:haxe.ds.Vector<ParticleSprite>;


	public function new(options:SpriteRenderModuleOptions) {

		super({});

		_premultipliedAlpha = true;
		_count = 0;
		_regionScaled = new Rectangle();
		_regionTmp = new Rectangle();

		region = options.region;
		texture = options.texture;

		_blendSrc = options.blendSrc != null ? options.blendSrc : BlendingFactor.BlendOne;
		_blendDst = options.blendDst != null ? options.blendDst : BlendingFactor.InverseSourceAlpha;
		_blendOp = options.blendOp != null ? options.blendOp : BlendingOperation.Add;

		// _alphaBlendSrc = options.alphaBlendSrc != null ? options.alphaBlendSrc : BlendingFactor.Undefined;
		// _alphaBlendDst = options.alphaBlendDst != null ? options.alphaBlendDst : BlendingFactor.Undefined;
		// _alphaBlendOp = options.alphaBlendOp != null ? options.alphaBlendOp : BlendingOperation.Add;

		blendMode = options.blendMode != null ? options.blendMode : BlendMode.NORMAL;

		if(options.premultipliedAlpha != null) {
			premultipliedAlpha = options.premultipliedAlpha;
		}

		if(pipeline == null) {
			pipeline = new PipelineState();
			pipeline.fragmentShader = kha.Shaders.painter_image_frag;
			pipeline.vertexShader = kha.Shaders.painter_image_vert;
			
			var structure = new VertexStructure();
			structure.add("vertexPosition", VertexData.Float3);
			structure.add("texPosition", VertexData.Float2);
			structure.add("vertexColor", VertexData.Float4);
			pipeline.inputLayout = [structure];
			
			pipeline.blendSource = BlendingFactor.BlendOne;
			pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
			pipeline.blendOperation = BlendingOperation.Add;

			// pipeline.alphaBlendSource = BlendingFactor.BlendOne;
			// pipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;
			// pipeline.alphaBlendOperation = BlendingOperation.Add;
			
			pipeline.compile();
		}

	}

	override function init() {

		_size = emitter.components.get(Size, false);
		_scale = emitter.components.get(Scale, false);
		_color = emitter.components.get(Color, false);
		_rotation = emitter.components.get(Rotation, false);
		_origin = emitter.components.get(Origin, false);
		_region = emitter.components.get(Region, false);

		_sizeDefault = new Size(32, 32);
		_scaleDefault = 1;
		_colorDefault = new Color(1,1,1,1);
		_rotationDefault = 0;
		_originDefault = new Origin(0.5, 0.5);

		if(_size != null) {
			for (i in 0...emitter.particles.capacity) {
				_size.get(i).copyFrom(_sizeDefault);
			}
		}

		if(_origin != null) {
			for (i in 0...emitter.particles.capacity) {
				_origin.get(i).copyFrom(_originDefault);
			}
		}

		if(_scale != null) {
			for (i in 0...emitter.particles.capacity) {
				_scale.set(i, _scaleDefault);
			}
		}

		if(_region != null) {
			for (i in 0...emitter.particles.capacity) {
				_region.get(i).set(0,0,1,1);
			}
		}

		_particleSprites = new haxe.ds.Vector(emitter.particles.capacity);
		_pSortTmp = new haxe.ds.Vector(emitter.particles.capacity);

		var p:Particle;
		for (i in 0...emitter.particles.capacity) {
			p = emitter.particles.get(i);
			_particleSprites[p.id] = new ParticleSprite();
		}

	}

	override function render(g) {

		var c:kha.Canvas = cast g;
		var g = c.g2;

		pipeline.blendSource = _blendSrc;
		pipeline.blendDestination = _blendDst;
		pipeline.blendOperation = _blendOp;
		// pipeline.alphaBlendSource = _alphaBlendSrc;
		// pipeline.alphaBlendDestination = _alphaBlendDst;
		// pipeline.alphaBlendOperation = _alphaBlendOp;

		g.pipeline = pipeline;

		var sortMode = emitter.getSortModeFunc();

		if(sortMode != null) {
			var p:Particle;
			var ps:ParticleSprite;

			_count = emitter.particles.length;

			for (i in 0..._count) {
				p = emitter.particles.get(i);
				ps = _particleSprites[i];
				ps.particleData = p;
				ps.size = _size != null ? _size.get(p.id) : _sizeDefault;
				ps.origin = _origin != null ? _origin.get(p.id) : _originDefault;
				ps.rotation = _rotation != null ? _rotation.get(p.id) : _rotationDefault;
				ps.scale = _scale != null ? _scale.get(p.id) : _scaleDefault;
				ps.color = _color != null ? _color.get(p.id) : _colorDefault;
				ps.region = _region != null ? getRegionScaled(_region.get(p.id)) : _regionScaled;
			}

			_sort(_particleSprites, _pSortTmp, 0, _count-1, sortMode);

			for (i in 0..._count) {
				ps = _particleSprites[i];
				renderParticle(
					g, 
					ps.particleData,
					ps.size,
					ps.origin,
					ps.rotation,
					ps.scale,
					ps.color,
					ps.region
				);
			}
		} else {
			for (p in emitter.particles) {
				renderParticle(
					g, 
					p,
					_size != null ? _size.get(p.id) : _sizeDefault,
					_origin != null ? _origin.get(p.id) : _originDefault,
					_rotation != null ? _rotation.get(p.id) : _rotationDefault,
					_scale != null ? _scale.get(p.id) : _scaleDefault,
					_color != null ? _color.get(p.id) : _colorDefault,
					_region != null ? getRegionScaled(_region.get(p.id)) : _regionScaled
				);
			}
		}

	}

	inline function renderParticle(
		g:kha.graphics2.Graphics, 
		particle:Particle, 
		size:Size, 
		origin:Origin, 
		rotation:Float, 
		scale:Float, 
		color:Color, 
		reg:Rectangle
	) {
		g.color = kha.Color.fromFloats(color.r, color.g, color.b, color.a);

        var lx:Float = emitter.system.posLocal.x;
        var ly:Float = emitter.system.posLocal.y;
		var x:Float = particle.x - origin.x * size.x + lx;
		var y:Float = particle.y - origin.y * size.y + ly;

        g.pushRotation(Mathf.radians(rotation), particle.x + lx, particle.y + ly);

		if(texture != null) {
			g.drawScaledSubImage(
				texture, 
				reg.x, reg.y, 
				reg.w, reg.h, 
				x, 
				y,
				size.x * scale, size.y * scale
			);
		} else {
			g.fillRect(x, y, size.x * scale, size.y * scale);
		}

        g.popTransformation();
		
	}	

	public function setBlending(
		blendSrc:BlendingFactor, 
		blendDst:BlendingFactor, 
		?blendOp:BlendingOperation
		// ?alphaBlendSrc:BlendingFactor, 
		// ?alphaBlendDst:BlendingFactor, 
		// ?alphaBlendOp:BlendingOperation
	) {
		
		_blendSrc = blendSrc;
		_blendDst = blendDst;
		_blendOp = blendOp != null ? blendOp : BlendingOperation.Add;	

		// _alphaBlendSrc = alphaBlendSrc != null ? alphaBlendSrc : BlendingFactor.Undefined;
		// _alphaBlendDst = alphaBlendDst != null ? alphaBlendDst : BlendingFactor.Undefined;
		// _alphaBlendOp = alphaBlendOp != null ? alphaBlendOp : blendOp;	

	}

	// merge sort
	function _sort(a:haxe.ds.Vector<ParticleSprite>, aux:haxe.ds.Vector<ParticleSprite>, l:Int, r:Int, compare:(p1:Particle, p2:Particle)->Int) { 
		
		if (l < r) {
			var m = Std.int(l + (r - l) / 2);
			_sort(a, aux, l, m, compare);
			_sort(a, aux, m + 1, r, compare);
			_merge(a, aux, l, m, r, compare);
		}

	}

	inline function _merge(a:haxe.ds.Vector<ParticleSprite>, aux:haxe.ds.Vector<ParticleSprite>, l:Int, m:Int, r:Int, compare:(p1:Particle, p2:Particle)->Int) { 

		var k = l;
		while (k <= r) {
			aux[k] = a[k];
			k++;
		}

		k = l;
		var i = l;
		var j = m + 1;
		while (k <= r) {
			if (i > m) a[k] = aux[j++];
			else if (j > r) a[k] = aux[i++];
			else if (compare(aux[j].particleData, aux[i].particleData) < 0) a[k] = aux[j++];
			else a[k] = aux[i++];
			k++;
		}
		
	}

	inline function getRegionScaled(r:Rectangle) {
		
		_regionTmp.set(
			_regionScaled.x + r.x * texture.realWidth,
			_regionScaled.y + r.y * texture.realHeight,
			r.w * texture.realWidth, 
			r.h * texture.realHeight
		);

		return _regionTmp;

	}

	function updateRegionScaled() {
		
		if(region != null) {
			_regionScaled.set(region.x, region.y, region.w, region.h);
		} else if(texture != null) {
			_regionScaled.set(0, 0, texture.realWidth, texture.realHeight);
		}

	}

	function updateBlending() {

		if(_premultipliedAlpha) {
			switch (blendMode) {
				case BlendMode.NONE: setBlending(BlendingFactor.BlendOne, BlendingFactor.BlendZero);
				case BlendMode.NORMAL: setBlending(BlendingFactor.BlendOne, BlendingFactor.InverseSourceAlpha);
				case BlendMode.ADD: setBlending(BlendingFactor.BlendOne, BlendingFactor.BlendOne);
				case BlendMode.MULTIPLY: setBlending(BlendingFactor.DestinationColor, BlendingFactor.InverseSourceAlpha);
				case BlendMode.SCREEN: setBlending(BlendingFactor.BlendOne, BlendingFactor.InverseSourceColor);
				case BlendMode.ERASE: setBlending(BlendingFactor.BlendZero, BlendingFactor.InverseSourceAlpha);
				case BlendMode.MASK: setBlending(BlendingFactor.BlendZero, BlendingFactor.SourceAlpha); //TODO: test this
				case BlendMode.BELOW: setBlending(BlendingFactor.InverseDestinationAlpha, BlendingFactor.DestinationAlpha); //TODO: test this
			}
		} else {
			switch (blendMode) {
				case BlendMode.NONE: setBlending(BlendingFactor.BlendOne, BlendingFactor.BlendZero);
				case BlendMode.NORMAL: setBlending(BlendingFactor.SourceAlpha, BlendingFactor.InverseSourceAlpha);
				case BlendMode.ADD: setBlending(BlendingFactor.SourceAlpha, BlendingFactor.DestinationAlpha);
				case BlendMode.MULTIPLY: setBlending(BlendingFactor.DestinationColor, BlendingFactor.InverseSourceAlpha);
				case BlendMode.SCREEN: setBlending(BlendingFactor.SourceAlpha, BlendingFactor.BlendOne);
				case BlendMode.ERASE: setBlending(BlendingFactor.BlendZero, BlendingFactor.InverseSourceAlpha);
				case BlendMode.MASK: setBlending(BlendingFactor.BlendZero, BlendingFactor.SourceAlpha); //TODO: test this
				case BlendMode.BELOW: setBlending(BlendingFactor.InverseDestinationAlpha, BlendingFactor.DestinationAlpha); //TODO: test this
			}
		}
		
	}

	function set_texture(v:Image):Image {

		texture = v;

		updateRegionScaled();

		return texture;

	}

	function set_region(v:Rectangle):Rectangle {

		region = v;

		updateRegionScaled();

		return region;

	}

	function set_blendMode(v:BlendMode):BlendMode {

		blendMode = v;
		updateBlending();

		return blendMode;
		
	}

	inline function get_premultipliedAlpha():Bool {

		return _premultipliedAlpha;
		
	}

	function set_premultipliedAlpha(v:Bool):Bool {

		_premultipliedAlpha = v;
		updateBlending();

		return _premultipliedAlpha;
		
	}


}

private class ParticleSprite {


	public var particleData:Particle;

	public var size:Size;
	public var scale:Scale;
	public var origin:Origin;
	public var rotation:Float;
	public var color:Color;
	public var region:Region;


	public function new() {}


}


typedef SpriteRenderModuleOptions = {

	>ParticleModuleOptions,
	
	@:optional var texture:Image;
	@:optional var region:Rectangle;

	@:optional var premultipliedAlpha:Bool;
	@:optional var blendMode:BlendMode;

	// custom blending
	@:optional var blendSrc:BlendingFactor;
	@:optional var blendDst:BlendingFactor;
	@:optional var blendOp:BlendingOperation;
	@:optional var alphaBlendSrc:BlendingFactor;
	@:optional var alphaBlendDst:BlendingFactor;
	@:optional var alphaBlendOp:BlendingOperation;

}

