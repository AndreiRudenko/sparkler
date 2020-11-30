## Sparkler  
A modular 2d particle system.

### Features  
* Macro-powered.
* Customizable.
* You can create custom `ParticleModule` to extend functionality.
* Local/World Space rendering.

### Sample Usage  

```haxe

var emitter = new ParticleEmitter<
	ColorListOverLifetimeModule,
	VelocityModule,
	KhaSpriteRendererModule
>({
	cacheSize: 512,
	lifetime: 2,
	emitterLifetime: 5,
	emitRate: 50,
	colorListOverLifetime: {
		ease: null,
		list: [
			{
				time: 0,
				value: 0xFFFF0000
			},
			{
				time: 0.5,
				value: 0xFFFF00FF
			},
			{
				time: 1,
				value: 0x00FF00FF
			}
		]
	},
	velocity: {x: 0, y: -200},
	khaSpriteRenderer: {
		image: kha.Assets.images.particle
	},
	sortFunc: function(a, b) {
		return a.age < b.age ? 1 : -1;
	}
});

emitter.start();


```