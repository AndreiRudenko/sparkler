
import luxe.GameConfig;
import luxe.Input;
import luxe.Color;
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
			rate : 128,
			cache_size : 512,
			cache_wrap : true,
			modules : [
				new particles.modules.SpawnModule(),
				new particles.modules.LifeTimeModule({
					lifetime : 0.5,
					lifetime_max : 1
				}),
				new particles.modules.VelocityModule({
					initial_velocity : new Vector(0, 100)
				}),
				new particles.modules.ColorLifeModule({
					initial_color : new Color(1,0,1,1),
					end_color : new Color(0,0,1,1),
					end_color_max : new Color(1,0,0,1)
				}),
				new particles.modules.SizeLifeModule({
					initial_size : new Vector(16,16),
					end_size : new Vector(8,8)
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
			if(pe.enabled) {
				ps.stop(true);
			} else {
				ps.start();
			}
		}

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
