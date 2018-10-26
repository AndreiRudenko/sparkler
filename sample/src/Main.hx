
import luxe.GameConfig;
import luxe.Input;
import luxe.Color;
import luxe.Vector;

import sparkler.ParticleSystem;
import sparkler.ParticleEmitter;
import sparkler.core.ParticleModule;
import sparkler.modules.*;


class Main extends luxe.Game {

	var ps:ParticleSystem;


	override function config(config:GameConfig) {

        config.preload.textures.push({ id:'assets/particle.png' });
		config.window.title = 'luxe game';
		config.window.width = 960;
		config.window.height = 640;
		config.window.fullscreen = false;

		return config;

	} //config


	override function ready() {

		sparkler.utils.ModulesFactory.init();

		ParticleSystem.renderer = new sparkler.render.luxe.LuxeRenderer();

		ps = new ParticleSystem();

		ps.add(new ParticleEmitter({
				name : 'test_emitter', 
				rate : 400,
				cache_size : 2048,
				lifetime : 2,
				lifetime_max : 4,
				cache_wrap : true,
				image_path: 'assets/particle.png',
				modules : [
					new SpawnModule(),
					new DirectionModule({
						direction_variance: 180,
						speed: 90
					}),
					new GravityModule({
						gravity : new sparkler.data.Vector(0, 90)
					}),
					new ScaleLifeModule({
						initial_scale : 1,
						end_scale : 0
					}),
					new ColorLifeModule({
						initial_color : new sparkler.data.Color(1,0,0),
						end_color : new sparkler.data.Color(0,0,1)
					}),
				]

			})
		);


	} //ready

	override function onkeyup(event:KeyEvent) {

		if(event.keycode == Key.escape) {
			Luxe.shutdown();
		}

		if(event.keycode == Key.space) {
			if(ps.emitters[0].enabled) {
				ps.stop(true);
			} else {
				ps.start();
			}
		}

	} //onkeyup

	override function onmousemove(event:MouseEvent) {

		ps.pos.set(event.pos.x, event.pos.y);


	} //onmousemove

	override function update(dt:Float) {

		Luxe.debug.start('particles');
		ps.update(dt);
		Luxe.debug.end('particles');

	} //update


} //Main
