## Sparkler  
Modular Particle System for [luxe](https://github.com/underscorediscovery/luxe)  

##### Overview  
* Create a `ParticleSystem` and add `ParticleEmitter` with modules that you like.
* You can create custom `ParticleModule` to extend functionality.
* Some modules need to have access to custom data, you can create components and add them to `ParticleEmitter`.  

##### Core
* `ParticleSystem` — particle system.
	* `active: Bool` — if the system is active, it will update.
	* `enabled: Bool` — whether or not this system is enabled.
	* `paused: Bool` — whether or not this system is paused.
	* `position: Vector` — the system position.
	* `emitters: Array<ParticleEmitter>` — the system emitters.
	* `add(e:ParticleEmitter): ParticleSystem` — add emitter to the system.
	* `remove(e:ParticleEmitter): Void` — remove a emitter from the system.
	* `emit(): Void` — emit particles.
	* `start(): Void` — start update emitters.
	* `stop(?kill:Bool): Void` — stop update emitters.
	* `pause(): Void` — pause.
	* `unpause(): Void` — unpause.
	* `empty(): Void` — destroy all emitters in this system.
* `ParticleEmitter` — particle emitter.
	* `active:Bool` — if the emitter is active, it will update.
	* `enabled: Bool` — if the emitter is enabled, it's spawn and update modules.
	* `name: String` — emitter name.
	* `position: Vector` — offset from system position.
	* `particles: ParticleVector` — emitter particles.
	* `components: ComponentManager` — particles components.
	* `modules: Map<String, ParticleModule>` — emitter modules.
	* `active_modules: Array<ParticleModule>` — active emitter modules.
	* `system: ParticleSystem` — reference to system.
	* `count:Int` — number of particles per emit.
	* `count_max:Int` — number of particles per emit max.
	* `lifetime:Float` — lifetime for particles.
	* `lifetime_max:Float` — max lifetime for particles.
	* `rate: Float` — emitter rate, particles per sec.
	* `rate_max: Float` — emitter rate, max particles per sec.
	* `duration: Float` — emitter duration.
	* `duration_max: Float` — emitter duration max.
	* `cache_size: Int` — emitter cache size.
	* `cache_wrap:Bool` — emitter cache wrap.
	* `random: Void -> Float` — emitter random function.
	* `image_path:String` — emitter particles image path.
	* `depth: Float` — emitter particles depth.
	* `add_module(m:ParticleModule): ParticleEmitter` — add module.
	* `get_module(mclass:Class<ParticleModule>): ParticleModule` — get module.
	* `remove_module(mclass:Class<ParticleModule>): ParticleModule` — remove module.
	* `enable_module(mclass:Class<ParticleModule>): Void` — enable module.
	* `disable_module(mclass:Class<ParticleModule>): Void` — disable module.
	* `emit(): Void` — emit particles.
	* `start(?duration:Float): Void` — start update modules.
	* `stop(?kill:Bool): Void` — stop update modules.
	* `pause(): Void` — pause.
	* `unpause(): Void` — unpause.

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
* `VelocityModule` — applies velocity to particle.
	* `initial_velocity: Vector` — initial particle velocity.
	* `initial_velocity_max: Vector` — initial particle velocity max.
	* `velocity_random: Vector` — random velocity during update.
* `VelocityLifeModule` — applies velocity to particle during life.
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
* `SizeLifeModule` — module scales the size of the particle by a given value over its lifetime.
	* `initial_size: Vector` — initial size.
	* `initial_size_max: Vector` — initial size maximum, if this not null, the size will be random between initial_size.
	* `end_size: Vector` — end size.
	* `end_size_max: Vector` — end size maximum, if this not null, the size will be random between end_size.
* `ScaleLifeModule` — module scales particle by a given value over its lifetime.
	* `initial_scale: Float` — initial scale.
	* `initial_scale_max: Float` — initial scale maximum, if this not null, the scale will be random between initial_scale.
	* `end_scale: Float` — end scale.
	* `end_scale_max: Float` — end scale maximum, if this not null, the scale will be random between end_scale.
* `CallbackModule` — spawn callbacks.
	* `onspawn_callback: Particle->ParticleEmitter->Void` — called when particle spawn.
	* `onunspawn_callback: Particle->ParticleEmitter->Void` — called when particle unspawn.

*Some modules is added automaticaly like `VelocityUpdateModule`, you don't need add them manually*


##### Components
*Components is added to `ParticleEmitter` from modules automaticaly.*
* `Velocity` — used by: `VelocityModule`, `VelocityLifeModule`, `ForceModule`, `GravityModule`, `DirectionModule`.

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
			lifetime : 1,
			lifetime_max : 2,
			cache_wrap : true,
			modules : [
				new particles.modules.SpawnModule(),
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
