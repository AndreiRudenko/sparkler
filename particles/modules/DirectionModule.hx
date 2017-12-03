package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.ParticleData;
import particles.core.Components;
import particles.components.Velocity;
import particles.modules.VelocityUpdateModule;



class DirectionModule extends ParticleModule {


	public var direction:Float;
	public var direction_variance:Float;
	public var speed:Float;
	public var speed_variance:Float;
	public var from_angle:Bool;

	var vel_comps:Components<Velocity>;
	var particles_data:Array<ParticleData>;


	public function new(_options:DirectionModuleOptions) {

		super();

		direction = _options.direction != null ? _options.direction : 0;
		direction_variance = _options.direction_variance != null ? _options.direction_variance : 0;
		speed = _options.speed != null ? _options.speed : 60;
		speed_variance = _options.speed_variance != null ? _options.speed_variance : 0;
		from_angle = _options.from_angle != null ? _options.from_angle : false;

	}

	override function init() {

		if(emitter.get_module(VelocityUpdateModule) == null) {
			emitter.add_module(new VelocityUpdateModule(), 999);
		}

		vel_comps = emitter.components.get(Velocity);

		particles_data = emitter.particles_data;

	}

	override function spawn(p:Particle) {

		var angle:Float = 0;

		if(from_angle) {
			var pd:ParticleData = particles_data[p.id];
			angle = angle_between_points(
					emitter.system.position.x + emitter.position.x, 
					emitter.system.position.y + emitter.position.y, 
					pd.x,
					pd.y
				);
			if(direction_variance != 0) {
				angle += (direction_variance * emitter.random_1_to_1()) * 0.017453292519943295;
			}
		} else {
			angle = (direction + direction_variance * emitter.random_1_to_1()) * 0.017453292519943295; // Math.PI / 180
		}

		var spd:Float = speed + speed_variance * emitter.random_1_to_1();

		var v:Velocity = vel_comps.get(p);
		v.x = spd * Math.cos(angle);
		v.y = spd * Math.sin(angle);

	}

	inline function angle_between_points(ax:Float, ay:Float, bx:Float, by:Float):Float {

		var dy:Float = by - ay;
		var dx:Float = bx - ax;

		return Math.atan2(dy, dx);

	}


}


typedef DirectionModuleOptions = {

	@:optional var direction : Float;
	@:optional var direction_variance : Float;
	@:optional var speed : Float;
	@:optional var speed_variance : Float;
	@:optional var from_angle : Bool;

}


