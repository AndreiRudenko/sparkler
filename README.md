## Sparkler  
Modular Particle System for [luxe](https://github.com/underscorediscovery/luxe)  

##### Overview  
* Create a `ParticleSystem` and `ParticleEmitter` with modules that you like.
* You can create custom `ParticleModule` to extend functionality.
* Some modules need to have access to same data, you can create components and add them to `ParticleEmitter`.  

##### Modules
* `SpawnModule` — simple spawn module.
* `AreaSpawnModule` — spawn particles in area.
	* `size: Vector` — area size.
	* `size_max: Vector` — area size max(it will spawn particles randomly between `size` and `size_max`).
	* `inside: Bool` — spawn particles inside area.
* `RadialSpawnModule` — spawn particles in circlular area.
	* `radius: Float` — circle radius.
	* `radius_max: Float` — circle radius max.
	* `inside: Bool` — spawn particles inside area.
* `LifeTimeModule` — particles lifetime.
	* `lifetime: Float` — particle lifetime.
	* `lifetime_max: Float` — particle lifetime max.
* `VelocityModule` — applies velocity to particle.
	* `initial_velocity: Vector` — initial particle velocity.
	* `initial_velocity_max: Vector` — initial particle velocity max.
	* `velocity_random: Vector` — random velocity during update.
* `VelocityLifeModule` — applies velocity to particle during life (requires LifeTimeModule).
	* `initial_velocity: Vector` — initial particle velocity.
	* `initial_velocity_max: Vector` — initial particle velocity max.
	* `end_velocity: Vector` — particle velocity at the end of lifetime.
	* `end_velocity_max: Vector` — max particle velocity at the end of lifetime.
	* `velocity_random: Vector` — random velocity during update.
* `ForceModule` — applies force to particle velocity during update.
	* `force: Vector` — force .
	* `force_random: Vector` — random force during update.
* `GravityModule` — applies gravity to particle.
	* `gravity: Vector` — gravity vector.
* `DirectionModule` — applies velocity towards direction.
	* `direction: Float` — direction in degrees.
	* `direction_variance: Float` — direction variance in degrees.
	* `speed: Float` — speed.
	* `speed_variance: Float` — speed variance.
	* `from_angle: Bool` — this will override direction to angle from spawn position, to emitter position.
* `SizeLifeModule` — module scales the size of the particle by a given value over its lifetime (requires LifeTimeModule).
	* `initial_size: Vector` — initial size.
	* `initial_size_max: Vector` — initial size maximum, if this not null, the size will be random between initial_size.
	* `end_size: Vector` — end size.
	* `end_size_max: Vector` — end size maximum, if this not null, the size will be random between end_size.
* `ScaleLifeModule` — module scales particle by a given value over its lifetime (requires LifeTimeModule).
	* `initial_scale: Float` — initial scale.
	* `initial_scale_max: Float` — initial scale maximum, if this not null, the scale will be random between initial_scale.
	* `end_scale: Float` — end scale.
	* `end_scale_max: Float` — end scale maximum, if this not null, the scale will be random between end_scale.
* `CallbackModule` — spawn callbacks.
	* `onspawn_callback: Particle->ParticleEmitter->Void` — called when particle spawn.
	* `onunspawn_callback: Particle->ParticleEmitter->Void` — called when particle unspawn.

*Some modules is added automaticaly like `VelocityUpdateModule` and `StartPosModule`, you don't need add them manually*
*There is more modules here, i will update next time.*


##### Components
*Components is added to `ParticleEmitter` from modules automaticaly.*
* `Life` — used by: `LifeTimeModule`.
* `Velocity` — used by: `VelocityModule`, `VelocityLifeModule`, `ForceModule`, `GravityModule`, `DirectionModule`.
* `StartPos` — used by: `RadialAccelModule`, `TangentalAccelModule`.

##### Example  
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
				new particles.modules.SpawnModule(),
				new particles.modules.LifeTimeModule({
					lifetime : 1,
					lifetime_max : 2
				}),
				new particles.modules.VelocityModule({
					initial_velocity : new Vector(0, -100),
					initial_velocity_variance : new Vector(20, 0)
				}),
				new particles.modules.GravityModule({
					gravity : new Vector(0, 200)
				}),
				new particles.modules.SizeLifeModule({
					initial_scale : 1,
					end_scale : 0
				}),
			]
		})
	);

}

override function update(dt:Float) {

	ps.update(dt);

}


```
