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
					initial_velocity : new Vector(0, 0),
					initial_velocity_variance : new Vector(0, 0)
				}),
				new particles.modules.ForceModule({
					force : new Vector(0, 0),
					force_random : new Vector(1000, 0)
				}),
				new particles.modules.GravityModule({
					gravity : new Vector(0, 200)
				}),
				new particles.modules.ScaleModule({
					initial_scale : 1,
					end_scale : 0
				}),
				new particles.modules.SizeModule({
					initial_size : new Vector(32,32),
					end_size : new Vector(32,32)
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
