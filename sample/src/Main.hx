
import luxe.GameConfig;
import luxe.Input;
import luxe.Vector;

import particles.ParticleSystem;
import particles.ParticleEmitter;


class Main extends luxe.Game {

	var ps:ParticleSystem;
	var pe:ParticleEmitter;


	override function config(config:GameConfig) {

		config.window.title = 'luxe game';
		config.window.width = 960;
		config.window.height = 640;
		config.window.fullscreen = false;

		return config;

	} //config


	override function ready() {

		ps = new ParticleSystem();

		pe = new ParticleEmitter({
			name : 'test_emitter', 
			// duration : -1,
			rate : 30,
			cache_size : 64,
			cache_wrap : true,
			modules : [
				new particles.modules.LifetimeModule({
					lifetime : 2
					// lifetime_max : 0
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
		});

		ps.add(pe);

	} //ready

	override function onkeyup(event:KeyEvent) {

		if(event.keycode == Key.escape) {
			Luxe.shutdown();
		}

		if(event.keycode == Key.space) {
			ps.emit();
		}

		// if(event.keycode == Key.key_q) {
		// 	pe.modules[2].enabled = !pe.modules[2].enabled;
		// }
		
		// if(event.keycode == Key.key_w) {
		// 	pe.modules[3].enabled = !pe.modules[3].enabled;
		// }

	} //onkeyup

	override function onmousemove(event:MouseEvent) {

		ps.position.copy_from(event.pos);

	} //onmousemove

	override function update(dt:Float) {

		Luxe.debug.start('particles');
		ps.update(dt);
		Luxe.debug.end('particles');

	} //update


} //Main
