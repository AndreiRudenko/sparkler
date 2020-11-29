
class Emitter {

	x { _x }
	x=(v) { _x=v }

	y { _y }
	y=(v) { _y=v }

	duration { _duration }
	duration=(v) { _duration=v }

	loops { _loops }
	loops=(v) { _loops=v }

	time { _time }

	enabled { _enabled }
	enabled=(v) { _enabled=v }

	rate { _rate }
	rate=(v) { _rate=v }

	frameTime { _frameTime }

	t { _t }

	construct new() {
		_t = 0
		_lastX = 0
		_lastY = 0
		_rate = 10
		_loops = 0
		_loopsCounter = 0
		_enabled = false
		_time = 0
		_duration = 1
		_frameTime = 0
	}

// 	update(elapsed) { 
// 		System.print("update begin")

// 		if (!enabled) {
// 			System.print("--inenabled--")
// 			return
// 		}

// 		System.print("--update-- {enabled: %(_enabled), elapsed: %(elapsed), time: %(_time)/%(_duration)(%(_duration - _time))}")

// 		if (_time + elapsed < _duration) {
// 			_time = _time + elapsed
// 			tick(elapsed)
// 		} else {
// 			var timeLeft = elapsed - (_duration - _time)
// 			tick(_duration - _time)
// 			_time = _duration
// 			if (_loops > 0 && _loopsCounter < _loops) {
// 				_loopsCounter = _loopsCounter + 1
// 				stopInternal()
// 				System.print("\n--loop--\n")
// 				startInternal(timeLeft)
// 			} else {
// 				stop()
// 			}
// 		}

// 		System.print("update end\n")
// 	}

	update2(elapsed) { 

// 		var t = elapsed
// 		_time = _time + elapsed
		while (_time + elapsed >= _duration) {
			updateInternal(_duration - _time)
// 			_t = _t + (_duration - _time)
			elapsed = elapsed - (_duration - _time)
			_time = _duration
			if (_loops >= 0 && _loopsCounter >= _loops) {
				stop()
				break
			}
			_loopsCounter = _loopsCounter + 1
			stopInternal()
			System.print("\n--loop--\n")
			startInternal()
		}

		if (elapsed > 0) {
// 			_t = _t + elapsed
			updateInternal(elapsed)
			_time = _time + elapsed
		}



// 		_frameTime = _frameTime + elapsed

// 		while (_frameTime >= _rate) {
// 			_frameTime =  _frameTime - _rate

// 			updateParticles(_rate)
// 		}

// 		if (elapsed > 0) {
// 			updateParticles(elapsed)
// 		}




// 		if (_time + elapsed < _duration) {
			
// 		} else {

// 		}
		
// 		_lastX = x
// 		_lastY = y
	}

	updateInternal(elapsed) { 
		System.print("--updateInternal-- {enabled: %(_enabled), elapsed: %(elapsed), time: %(_time)/%(_duration)(%(_duration - _time))}")

		var invRate = 1 / rate

		while (_enabled && _frameTime + elapsed >= invRate) {
			updateParticles(invRate - _frameTime)
			elapsed = elapsed - (invRate - _frameTime)
			_frameTime = 0
			System.print("t:%(invRate - _frameTime) --emit-- {frameTime: %(_frameTime)/%(invRate)(%(invRate - _frameTime))}")
			_t = _t + (invRate - _frameTime)
			emit()
		}

		if (elapsed > 0) {		
			if (_enabled) {
				_t = _t + elapsed
				_frameTime = _frameTime + elapsed
				System.print("add frameTime {frameTime: %(_frameTime)/%(invRate)(%(invRate - _frameTime))}")
			}
			updateParticles(elapsed)
		}
// 		_frameTime = _frameTime + elapsed

// 		while (_frameTime >= _rate) {
// 			_frameTime =  _frameTime - _rate

// // 			updateParticles(_rate)
// 		}

	}

	updateParticles(elapsed) {
		System.print("t:%(elapsed) --updateParticles-- {enabled: %(_enabled), elapsed: %(elapsed), time: %(_time)/%(_duration)(%(_duration - _time))}")

	}

	emit() { 
		System.print("--emit-- %(_t)")
	}

	/*
	
	elapsed
	|....|....|....|
	
	rate
	|..|..|..|..|

	duration
	|..........|
	



	 */

// 	updateInternal2(elapsed){

// 	}

// 	update(elapsed) { 
// 		System.print("update begin")
// 		if (!enabled) {
// 			System.print("--inenabled--")
// 			return
// 		}

// 		System.print("--update-- {enabled: %(_enabled), elapsed: %(elapsed), time: %(_time)/%(_duration)(%(_duration - _time))}")

// // 		while (enabled && elapsed > _duration - _time) {
// // 			System.print("->while<-")
// // 			elapsed = elapsed - (_duration - _time)
// // 			updateInternal(_duration - _time)
// // 		}

// 		while (enabled && elapsed > _duration) {
// 			System.print("->while<-")
// 			elapsed = elapsed - _duration
// 			updateInternal(_duration)
// 		}

// 		if (enabled && elapsed > 0) {
// 			updateInternal(elapsed)
// 		}


// // 		System.print(_time)
// // 		while(enabled && elapsed > _duration - _time) {
// // 			elapsed -= _duration - _time
// // 			updateInternal(_duration - _time)
// // 		}
// 		System.print("update end\n")
// 	}

// 	updateInternal(elapsed) { 
// 		System.print("--updateInternal-- {enabled: %(_enabled), elapsed: %(elapsed), time: %(_time)/%(_duration)(%(_duration - _time))}")

// // 		_time = _time + elapsed

// 		if (_time + elapsed >= _duration) {
// 			tick(_duration - _time)
// 			elapsed = elapsed - (_duration - _time)
// 			_time = _duration
// 			if (_loops > 0 && _loopsCounter < _loops) {
// 				_loopsCounter = _loopsCounter + 1
// 				stopInternal()
// 				System.print("\n--loop--\n")
// 				startInternal(elapsed)
// 			} else {
// 				stop()
// 			}
// 		} else {
// 			_time = _time + elapsed
// 			tick(elapsed)
// 		}
// 	}

	tick(elapsed) { 
		System.print("--tick-- %(elapsed)")
// 		if(enabled && rate > 0) {
// 			_frameTime += elapsed;
// 			var _invRate:Float = 1/rate;
// 			while(_frameTime > 0) {
// 				emit();
// 				_frameTime -= _invRate;
// 				// TODO: update here
// 			}
// 		}

	}

// 	startInternal() { 
// 		startInternal(0)
// 	}

	startInternal() { 
// 		System.print("//startInternal// {from: %(from), time: %(_time)/%(_duration)(%(_duration - _time))}")
		System.print("//startInternal// {time: %(_time)/%(_duration)(%(_duration - _time))}")
		_enabled = true
		_time = 0
		_frameTime = 0
		_t = 0
// 		if (from > 0) {
// 			update(from)
// 		}
	}

	stopInternal() { 
		System.print("//stopInternal// {time: %(_time)/%(_duration)(%(_duration - _time))}")
		_enabled = false
	}

	start() { 
		System.print("//start//")
		_loopsCounter = 0
		startInternal()
	}

	stop() { 
		System.print("//stop//")
		stopInternal()
	}
	
}

var iter = 10
var elapsed = 4

var e = Emitter.new()

e.rate = 1/3
e.loops = -1
e.duration = 5

e.start()

for (i in 0...iter) {
	System.print("--------------------")
	e.update2(elapsed)
}