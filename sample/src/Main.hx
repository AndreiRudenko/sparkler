
import luxe.GameConfig;
import luxe.Input;
import luxe.Color;
import luxe.Vector;

import sparkler.ParticleSystem;
import sparkler.ParticleEmitter;
import sparkler.modules.AreaSpawnModule;


class Main extends luxe.Game {

	var ps:ParticleSystem;
	var pe:ParticleEmitter;


	override function config(config:GameConfig) {

		config.window.title = 'sparkler luxe';
		config.window.width = 960;
		config.window.height = 640;
		config.window.fullscreen = false;

		return config;

	} //config


	override function ready() {

		sparkler.ParticleSystem.backend = new sparkler.backend.LuxeBackend();
		sparkler.utils.ModulesFactory.init();

		ps = new ParticleSystem();

		pe = new ParticleEmitter({
			name : 'test_emitter', 
			// duration : -1,
			rate : 128,
			cache_size : 512,
			cache_wrap : true,
			modules : [
				new sparkler.modules.AreaSpawnModule({
					size : new Vector(64,64),
					size_max : new Vector(128,128)
				}),
				new sparkler.modules.ColorLifeModule({
					initial_color : new Color(1,0,1,1),
					end_color : new Color(0,0,1,1),
					end_color_max : new Color(1,0,0,1)
				}),
				new sparkler.modules.SizeLifeModule({
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
			// ps.emit();
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

		ps.update(dt);

	} //update


} //Main
