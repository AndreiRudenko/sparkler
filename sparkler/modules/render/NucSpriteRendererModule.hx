package sparkler.modules.render;

import sparkler.utils.macro.ParticleEmitterMacro;
import sparkler.utils.macro.MacroUtils;
import sparkler.ParticleModule;
import sparkler.Particle;

import haxe.macro.Context;
import haxe.macro.Expr;

#if !macro
import nuc.graphics.Texture;
import nuc.math.FastTransform2;

class NucSpriteRenderer {

	public var texture:Texture;

	@:noCompletion public var _transform:FastTransform2 = new FastTransform2();

	public function new() {}

}
#end

@group('renderer')
class NucSpriteRendererModule extends ParticleInjectModule {

#if (macro || display)
	static public function inject(options:ParticleEmitterBuildOptions) {
		var pos = Context.currentPos();

		var fields = options.fields;
		var particleType = options.particleType;
		var particleFieldNames = options.particleFieldNames;
		var newExprs = options.newExprs;
		var optFields = options.optFields;

		var textureOptVar = MacroUtils.buildVar(
			'nucSpriteRenderer', 
			[Access.APublic], 
			macro: {
				?texture:nuc.graphics.Texture
			}, 
			null, 
			[{name: ':optional', pos: pos}]
		);
		optFields.push(textureOptVar);

		var nucSpriteRendererVar = MacroUtils.buildVar('nucSpriteRenderer', [Access.APublic], macro: sparkler.modules.render.NucSpriteRendererModule.NucSpriteRenderer);
		fields.push(nucSpriteRendererVar);

		newExprs.push(macro {
			nucSpriteRenderer = new sparkler.modules.render.NucSpriteRendererModule.NucSpriteRenderer();
			if(options.nucSpriteRenderer != null) {
				if(options.nucSpriteRenderer.texture != null) nucSpriteRenderer.texture = options.nucSpriteRenderer.texture;
			}
		});

		var preExprs:Array<Expr> = [];
		var exprsBeginLocal:Array<Expr> = [];
		var exprsEndLocal:Array<Expr> = [];
		var exprsBegin:Array<Expr> = [];
		var exprsEnd:Array<Expr> = [];

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
			exprsBegin.push(
				macro {
					g.pushTransform();
					g.rotate(sparkler.utils.Maths.radians(p.rotation), p.x, p.y);
				}
			);
			exprsEnd.push(
				macro {
					g.popTransform();
				}
			);

			exprsBeginLocal.push(
				macro {
					var rx = t.getTransformX(p.x, p.y);
					var ry = t.getTransformY(p.x, p.y);
					g.pushTransform();
					g.rotate(sparkler.utils.Maths.radians(p.rotation), rx, ry);
				}
			);
			exprsEndLocal.push(
				macro {
					g.popTransform();
				}
			);
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
			exprsBeginLocal.push(
				macro {
					g.color = p.color.value;
				}
			);
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

		var drawExpr = macro {
			g.drawImage(
				texture, p.x - $originXexpr * $scaleExpr, p.y - $originYexpr * $scaleExpr,
				$sizeXexpr * $scaleExpr, $sizeYexpr * $scaleExpr, 
				$regionXexpr, $regionYexpr, $regionWexpr, $regionHexpr
			);
		};

		var drawFunc = MacroUtils.buildFunction(
			'draw', 
			[Access.APublic], 
			[{name: 'g', type: macro: nuc.graphics.SpriteBatch}],
			macro: Void,
			[macro {
				if(activeCount > 0) {
					var sortedParticles = getSorted();
					var texture = nucSpriteRenderer.texture;

					$b{preExprs}

					if(localSpace) {
						var t = nucSpriteRenderer._transform.set(_a, _b, _c, _d, _tx, _ty);
						t.set(_a, _b, _c, _d, _tx, _ty);
						g.pushTransform(t);

						var p;
						var i:Int = 0;
						while(i < activeCount) {
							p = sortedParticles[i];
							$b{exprsBeginLocal}
							$e{drawExpr}
							$b{exprsEndLocal}
							i++;
						}
						g.popTransform();
					} else {
						var p;
						var i:Int = 0;
						while(i < activeCount) {
							p = sortedParticles[i];
							$b{exprsBegin}
							$e{drawExpr}
							$b{exprsEnd}
							i++;
						}
					}
				}
			}]
		);
		fields.push(drawFunc);

	}

#end

}
