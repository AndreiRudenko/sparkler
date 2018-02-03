
import luxe.GameConfig;
import luxe.Input;
import luxe.Color;
import luxe.Vector;

import sparkler.core.Particle;
import sparkler.ParticleSystem;
import sparkler.ParticleEmitter;
import sparkler.core.ParticleModule;
import sparkler.modules.RadialSpawnModule;
import sparkler.modules.AreaSpawnModule;
// import sparked.Editor;


class Main extends luxe.Game {

	var ps:ParticleSystem;
	var ps2:ParticleSystem;
	var pe:ParticleEmitter;
	var pe2:ParticleEmitter;


	override function config(config:GameConfig) {

		config.window.title = 'luxe game';
		config.window.width = 960;
		config.window.height = 640;
		config.window.fullscreen = false;

		return config;

	} //config


	override function ready() {

		sparkler.utils.ModuleTools.init();

		ps = new ParticleSystem();


		pe = new ParticleEmitter({
			name : 'test_emitter', 
			// duration : -1,
			rate : 128,
			cache_size : 512,
			cache_wrap : true,
			// modules_data : [{ name : 'sparkler.modules.SizeLifeModule'}],
			modules : [
				// new sparkler.modules.SpawnModule(),
				// new sparkler.modules.RadialSpawnModule({
				// 	radius : 64,
				// 	radius_max : 128,
				// 	inside : false
				// }),
				new sparkler.modules.AreaSpawnModule({
					size : new Vector(64,64),
					size_max : new Vector(128,128),
					inside : false
				}),
				new sparkler.modules.LifeTimeModule({
					lifetime : 2
					// lifetime_max : 1
				}),
				// new sparkler.modules.DirectionModule({
				// 	direction : 0,
				// 	direction_variance : 0,
				// 	speed : 60,
				// 	from_angle : true
				// }),
				// new sparkler.modules.VelocityModule({
				// 	initial_velocity : new Vector(0, 100),
				// 	// initial_velocity_variance : new Vector(0, 0)
				// }),

				// new sparkler.modules.RadialAccelModule({
				// 	accel : -60
				// }),
				// new sparkler.modules.TangentalAccelModule({
				// 	accel : 100
				// }),
				// new sparkler.modules.ForceModule({
				// 	force : new Vector(0, 0),
				// 	force_random : new Vector(2000, 0)
				// }),
				// new sparkler.modules.VelocityLifeModule({
				// 	initial_velocity : new Vector(0, 0),
				// 	end_velocity : new Vector(0, 100),
				// 	// initial_velocity_variance : new Vector(0, 0)
				// }),
				// new sparkler.modules.GravityModule({
				// 	gravity : new Vector(0, 200)
				// }),
				// new sparkler.modules.ScaleLifeModule({
				// 	initial_scale : 1,
				// 	end_scale : 0
				// }),
				// new sparkler.modules.RotationModule({
				// 	initial_rotation : 0,
				// 	end_rotation : 2,
				// 	end_rotation_max : -2,
				// 	use_life : true
				// }),
				new sparkler.modules.ColorLifeModule({
					initial_color : new Color(1,0,1,1),
					end_color : new Color(0,0,1,1),
					end_color_max : new Color(1,0,0,1)
				}),
				new sparkler.modules.SizeLifeModule({
					initial_size : new Vector(16,16),
					end_size : new Vector(8,8)
				})
				// new sparkler.modules.CallbackModule({
				// 	onunspawn : function(p:Particle, em:ParticleEmitter) {
				// 		var pd = em.particles_data[p.id];
				// 		ps2.position.set_xy(pd.x, pd.y);
				// 		ps2.emit();
				// 		// trace('unspawn: $p');
				// 		// trace('ps2 pos: ${ps2.position}');
				// 	}
				// })
			]
		});
		ps.add(pe);

		ps2 = new ParticleSystem();

		var json = pe.to_json();
		// json.name = 'dsadasdads';
		var pe2 = new ParticleEmitter(json);
		ps2.add(pe2);

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

		// if(event.keycode == Key.key_q) {
		// 	pe.modules[2].enabled = !pe.modules[2].enabled;
		// }
		
		// if(event.keycode == Key.key_w) {
		// 	pe.modules[3].enabled = !pe.modules[3].enabled;
		// }

	} //onkeyup

	override function onmousemove(event:MouseEvent) {

		ps.position.copy_from(event.pos);

		ps2.position.copy_from(new Vector(event.pos.x + 256, event.pos.y));


	} //onmousemove

	override function update(dt:Float) {

		Luxe.debug.start('particles');
		ps.update(dt);
		ps2.update(dt);
		Luxe.debug.end('particles');

	} //update


} //Main
