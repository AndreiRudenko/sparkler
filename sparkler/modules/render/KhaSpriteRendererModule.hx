package sparkler.modules.render;

import sparkler.utils.macro.ParticleEmitterMacro;
import sparkler.utils.macro.MacroUtils;
import sparkler.ParticleModule;

import haxe.macro.Context;
import haxe.macro.Expr;

#if !macro
import kha.Image;
import kha.math.FastMatrix3;

class KhaSpriteRenderer {

	public var image:Image;
	
	@:noCompletion public var _imageDefault:Image;
	@:noCompletion public var _transform:FastMatrix3 = FastMatrix3.identity();

	public function new() {
		_imageDefault = Image.create(1,1);
		var pixels = _imageDefault.lock();
		pixels.setInt32(0, 0xffffffff);
		_imageDefault.unlock();
	}

}
#end

@group('renderer')
class KhaSpriteRendererModule extends ParticleInjectModule {

#if (macro || display)
	static public function inject(options:ParticleEmitterBuildOptions) {
		var pos = Context.currentPos();

		var fields = options.fields;
		var particleType = options.particleType;
		var particleFieldNames = options.particleFieldNames;
		var newExprs = options.newExprs;
		var optFields = options.optFields;

		var imageOptVar = MacroUtils.buildVar(
			'khaSpriteRenderer', 
			[Access.APublic], 
			macro: {
				?image:kha.Image
			}, 
			null, 
			[{name: ':optional', pos: pos}]
		);
		optFields.push(imageOptVar);

		var khaSpriteRendererVar = MacroUtils.buildVar('khaSpriteRenderer', [Access.APublic], macro: sparkler.modules.render.KhaSpriteRendererModule.KhaSpriteRenderer);
		fields.push(khaSpriteRendererVar);

		newExprs.push(macro {
			khaSpriteRenderer = new sparkler.modules.render.KhaSpriteRendererModule.KhaSpriteRenderer();
			if(options.khaSpriteRenderer != null) {
				if(options.khaSpriteRenderer.image != null) khaSpriteRenderer.image = options.khaSpriteRenderer.image;
			}
		});

		var preExprs:Array<Expr> = [];
		var exprsBegin:Array<Expr> = [];
		var exprsEnd:Array<Expr> = [];

		var sizeXexpr = macro 32.0;
		var sizeYexpr = macro 32.0;

		var scaleExpr = macro 1.0;

		var originXexpr = macro 16.0;
		var originYexpr = macro 16.0;

		var regionXexpr = macro 0;
		var regionYexpr = macro 0;
		var regionWexpr = macro image.width;
		var regionHexpr = macro image.height;

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
			exprsBegin.push(
				macro {
					g.pushRotation(p.rotation, p.x, p.y);
				}
			);
			exprsEnd.push(
				macro {
					g.popTransformation();
				}
			);
		}

		if(particleFieldNames.indexOf('region') != -1) {
			regionXexpr = macro p.region.x;
			regionYexpr = macro p.region.y;
			regionWexpr = macro p.region.w;
			regionHexpr = macro p.region.h;
		}

		if(particleFieldNames.indexOf('color') != -1) {
			exprsBegin.push(
				macro {
					g.color = p.color.value;
				}
			);
		} else {
			preExprs.push(
				macro {
					g.color = 0xFFFFFFFF;
				}
			);
		}

		var drawFunc = MacroUtils.buildFunction(
			'draw', 
			[Access.APublic], 
			[{name: 'g', type: macro: kha.graphics2.Graphics}],
			macro: Void,
			[macro {
				if(activeCount > 0) {
					var sortedParticles = getSorted();
					var image = khaSpriteRenderer.image;
					if(image == null) image = khaSpriteRenderer._imageDefault;

					if(localSpace) {
						var t = khaSpriteRenderer._transform;
						t._00 = _a;
						t._01 = _b;
						t._10 = _c;
						t._11 = _d;
						t._20 = _tx;
						t._21 = _ty;
						g.pushTransformation(t);
					}

					$b{preExprs}

					var p;
					var i:Int = 0;
					while(i < activeCount) {
						p = sortedParticles[i];
						$b{exprsBegin}
						g.drawScaledSubImage(
							image, 
							$regionXexpr, $regionYexpr, $regionWexpr, $regionHexpr,
							p.x - $originXexpr * $scaleExpr, p.y - $originYexpr * $scaleExpr,
							$sizeXexpr * $scaleExpr, $sizeYexpr * $scaleExpr
						);
						$b{exprsEnd}
						i++;
					}

					if(localSpace) {
						g.popTransformation();
					}
				}
			}]
		);
		fields.push(drawFunc);

	}

#end

}
