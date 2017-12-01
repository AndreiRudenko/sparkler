## sparkler  
Modular Particle System for [luxe](https://github.com/underscorediscovery/luxe)


## example  
See sample/src/Main.hx

```haxe

//...

var ps:ParticleSystem;

override function ready() {

	ps = new ParticleSystem();

	ps.add( 
		new ParticleEmitter({
			name : 'test_emitter', 
			rate : 30,
			cache_size : 64,
			cache_wrap : true,
			modules : [
				new particles.modules.LifetimeModule({
					lifetime : 2
				}),
				new particles.modules.VelocityModule({
					initial_velocity : new Vector(0, -100),
					initial_velocity_variance : new Vector(0, 20)
				}),
				new particles.modules.GravityModule({
					gravity : new Vector(0, 200)
				}),
				new particles.modules.ScaleModule({
					initial_scale : 1,
					end_scale : 0
				}),
				new particles.modules.SpawnModule({  // SpawnModule must be last
					position_variance : new Vector(64,64)
				})
			]
		})
	);

}

override function update(dt:Float) {

	ps.update(dt);

}


```

## modules    

All particle emitters must have SpawnModule, and it should be added last, to update and sync particle position after other modules changes.

Later i will add more modules.
If you interested to contribute, it will be nice to have more modules.
Maybe it will be better to separate modules repo.
