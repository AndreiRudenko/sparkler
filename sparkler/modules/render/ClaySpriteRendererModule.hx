package sparkler.modules.render;

import sparkler.utils.macro.ParticleEmitterMacro;
import sparkler.utils.macro.MacroUtils;
import sparkler.ParticleModule;
import sparkler.Particle;

import haxe.macro.Context;
import haxe.macro.Expr;

#if !macro
import clay.graphics.Texture;
import clay.math.FastMatrix3;

class ClaySpriteRenderer {

	public var texture:Texture;

	@:noCompletion public var _transformPrev:FastMatrix3 = new FastMatrix3();
	@:noCompletion public var _transform:FastMatrix3 = new FastMatrix3();
	@:noCompletion public var _drawMatrix:FastMatrix3 = new FastMatrix3();

	public function new() {}

}
#end

@inject
@group('renderer')
class ClaySpriteRendererModule extends ParticleModule<ParticleBase> {

#if (macro || display)
	static public function inject(options:ParticleEmitterBuildOptions) {
		var pos = Context.currentPos();

		var fields = options.fields;
		var particleType = options.particleType;
		var particleFieldNames = options.particleFieldNames;
		var newExprs = options.newExprs;
		var optFields = options.optFields;

		var textureOptVar = MacroUtils.buildVar(
			'claySpriteRenderer', 
			[Access.APublic], 
			macro: {
				?texture:clay.graphics.Texture
			}, 
			null, 
			[{name: ':optional', pos: pos}]
		);
		optFields.push(textureOptVar);

		var claySpriteRendererVar = MacroUtils.buildVar('claySpriteRenderer', [Access.APublic], macro: sparkler.modules.render.ClaySpriteRendererModule.ClaySpriteRenderer);
		fields.push(claySpriteRendererVar);

		newExprs.push(macro {
			claySpriteRenderer = new sparkler.modules.render.ClaySpriteRendererModule.ClaySpriteRenderer();
			if(options.claySpriteRenderer != null) {
				if(options.claySpriteRenderer.texture != null) claySpriteRenderer.texture = options.claySpriteRenderer.texture;
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

		var skewXexpr = macro 0.0;
		var skewYexpr = macro 0.0;

		var regionXexpr = macro 0;
		var regionYexpr = macro 0;
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
			rotationExpr = macro p.rotation * (6.28318530717958648 / 360); // degrees to radians convertion
		}

		if(particleFieldNames.indexOf('skew') != -1) {
			skewXexpr = macro p.skew.x;
			skewYexpr = macro p.skew.y;
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
			[{name: 'batcher', type: macro: clay.graphics.batchers.SpriteBatch}],
			macro: Void,
			[macro {
				if(activeCount > 0) {
					var sortedParticles = getSorted();
					var texture = claySpriteRenderer.texture;
					var drawMatrix = claySpriteRenderer._drawMatrix;

					if(localSpace) {
						claySpriteRenderer._transformPrev.copyFrom(batcher.transform);
						claySpriteRenderer._transform.set(_a, _b, _c, _d, _tx, _ty);
						batcher.transform = claySpriteRenderer._transform;
					}

					$b{preExprs}
					var p;
					var i:Int = 0;
					while(i < activeCount) {
						p = sortedParticles[i];
						$b{exprs}

						drawMatrix.setTransform(
							p.x, p.y, 
							$rotationExpr,
							$scaleExpr, $scaleExpr, 
							$originXexpr, $originYexpr,
							$skewXexpr, $skewYexpr
						);

						batcher.drawImageTransform(
							texture,
							drawMatrix,
							$sizeXexpr, $sizeYexpr, 
							$regionXexpr, $regionYexpr, $regionWexpr, $regionHexpr
						);
						i++;
					}

					if(localSpace) {
						batcher.transform = claySpriteRenderer._transformPrev;
					}
				}
			}]
		);
		fields.push(drawFunc);

	}

#end

}
