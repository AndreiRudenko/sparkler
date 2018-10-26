## Sparkler  
Modular Particle System 

##### Overview  
* Create a `ParticleSystem` and add `ParticleEmitter` with modules that you like.  
* You can create custom `ParticleModule` to extend functionality.  
* Some modules need to have access to custom data, you can create components and add them to `ParticleEmitter`.  
* Additional modules: [sparkler_modules](https://github.com/RudenkoArts/sparkler_modules).  
* Can support multiple engines, now supports [luxe](https://github.com/underscorediscovery/luxe) and [Kha](https://github.com/Kode/Kha), but you can add another [renderer](https://github.com/RudenkoArts/sparkler/tree/master/sparkler/render) too, or create pull request, i will add it.  

##### Example  
See sample/src/Main.hx  

```haxe

//...
import sparkler.ParticleSystem;
import sparkler.ParticleEmitter;
import sparkler.modules.*;

var ps:ParticleSystem;

override function ready() {

	// setup renderer
	sparkler.ParticleSystem.renderer = new sparkler.render.luxe.LuxeRenderer();

	// create particle system
	ps = new ParticleSystem();

	// create emitter with modules, and add to particle system
	ps.add( 
		new ParticleEmitter({
			name : 'test_emitter', 
			rate : 30,
			cache_size : 64,
			lifetime : 1,
			lifetime_max : 2,
			cache_wrap : true,
			modules : [
				new SpawnModule(),
				new DirectionModule({
					direction_variance : 180
				}),
				new GravityModule({
					gravity : new Vector(0, 200)
				}),
				new SizeLifeModule({
					initial_scale : 1,
					end_scale : 0
				}),
			]
		})
	);

}

override function update(dt:Float) {

	// update particle system
	ps.update(dt);

}


```
