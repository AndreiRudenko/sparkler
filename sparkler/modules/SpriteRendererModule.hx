package sparkler.modules;

import sparkler.utils.ParticleEmitterMacro;
import sparkler.utils.Vector2;
import sparkler.utils.MacroUtils;
import sparkler.utils.SortMode;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

import haxe.macro.Context;
import haxe.macro.Expr;

#if !macro
import clay.graphics.Texture;

class SpriteRenderer {

	public var image(get, set):String;
	var _image:String;
	inline function get_image() return _image; 
	function set_image(v:String):String {
		_texture = clay.Clay.resources.texture(v);
		if(_texture == null) _texture = _defaultTexture;
		return _image = v;
	}
	
	@:noCompletion public var _texture:Texture;
	var _defaultTexture:Texture;

	public function new() {
		_defaultTexture = Texture.create(1, 1, TextureFormat.RGBA32);
		var pixels = _defaultTexture.lock();
		pixels.setInt32(0, 0xffffffff);
		_defaultTexture.unlock();
	}

}
#end

@group('renderer')
class SpriteRendererModule extends ParticleInjectModule {

#if (macro || display)
	static public function inject(options:ParticleEmitterBuildOptions) {
		var pos = Context.currentPos();

		var fields = options.fields;
		var particleType = options.particleType;
		var particleFieldNames = options.particleFieldNames;
		var newExprs = options.newExprs;
		var optFields = options.optFields;

		// var pct = Context.toComplexType(particleType);

		var imageOptVar = MacroUtils.buildVar(
			'spriteRenderer', 
			[Access.APublic], 
			macro: {
				image:String, 
				// ?sortMode:sparkler.utils.SortMode,
				// ?sortFunc:(a:$pct, b:$pct)->Int
			}, 
			null, 
			[{name: ':optional', pos: pos}]
		);
		optFields.push(imageOptVar);

		var spriteRendererVar = MacroUtils.buildVar('spriteRenderer', [Access.APublic], macro: sparkler.modules.SpriteRendererModule.SpriteRenderer);
		fields.push(spriteRendererVar);

		newExprs.push(macro {
			spriteRenderer = new sparkler.modules.SpriteRendererModule.SpriteRenderer();
			if(options.spriteRenderer != null) {
				if(options.spriteRenderer.image != null) spriteRenderer.image = options.spriteRenderer.image;
			}
		});

		var preExprs:Array<Expr> = [];
		var exprs:Array<Expr> = [];

		var sizeXexpr = macro 32.0;
		var sizeYexpr = macro 32.0;

		var scaleExpr = macro 1.0;

		var rotationExpr = macro 0.0;

		var originXexpr = macro 16.0;
		var originYexpr = macro 16.0;

		var regionXexpr = macro null;
		var regionYexpr = macro null;
		var regionWexpr = macro null;
		var regionHexpr = macro null;

		var hasOrigin = particleFieldNames.indexOf('origin') != -1;

		if(hasOrigin) {
			originXexpr = macro p.origin.x;
			originYexpr = macro p.origin.y;
		}

		if(particleFieldNames.indexOf('size') != -1) {
			sizeXexpr = macro p.size.x;
			sizeYexpr = macro p.size.y;
			if(!hasOrigin) {
				originXexpr = macro (p.size.x / 2);
				originYexpr = macro (p.size.y / 2);
			}
		}

		if(particleFieldNames.indexOf('scale') != -1) {
			scaleExpr = macro p.scale;
		}

		if(particleFieldNames.indexOf('rotation') != -1) {
			rotationExpr = macro p.rotation;
		}

		if(particleFieldNames.indexOf('region') != -1) {
			regionXexpr = macro p.region.x;
			regionYexpr = macro p.region.y;
			regionWexpr = macro p.region.w;
			regionHexpr = macro p.region.h;
		}

		if(particleFieldNames.indexOf('color') != -1) {
			exprs.push(
				macro {
					batcher.color = p.color.value;
				}
			);
		} else {
			preExprs.push(
				macro {
					batcher.color = 0xFFFFFFFF;
				}
			);
		}

		var drawFunc = MacroUtils.buildFunction(
			'draw', 
			[Access.APublic], 
			[{name: 'batcher', type: macro: clay.graphics.batchers.SpriteBatch}], // batcher
			macro: Void,
			[macro {
				if(particlesCount > 0) {
					var sortedParticles = getSorted();
					var texture = spriteRenderer._texture;
					// if(localSpace) {
						// batcher.transform.copyFrom(combined);
					// }

					$b{preExprs}
					var p;
					var i:Int = 0;
					while(i < particlesCount) {
						p = sortedParticles[i];
						$b{exprs}
						batcher.drawImage(
							texture,
							p.x, p.y,
							$sizeXexpr * $scaleExpr, $sizeYexpr * $scaleExpr,
							$rotationExpr,
							$originXexpr * $scaleExpr, $originYexpr * $scaleExpr,
							$regionXexpr, $regionYexpr, $regionWexpr, $regionHexpr
						);
						i++;
					}
				}
			}]
		);
		fields.push(drawFunc);

	}

#end

}

