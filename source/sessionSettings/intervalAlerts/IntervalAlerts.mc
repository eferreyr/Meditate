using Toybox.Graphics as Gfx;

module IntervalAlertType {
	enum {
		OneOff = 1,
		Repeat = 2
	}
}

class IntervalAlerts {
	private var mAlerts;
	
	function initialize() {
		me.reset();
	}
			
	function addNew() {
		me.mAlerts.add(new Alert());
		var newAlertIndex = me.mAlerts.size() - 1;
		return newAlertIndex;
	}
	
	function delete(index) {
		var alert = me.mAlerts[index];
		me.mAlerts.remove(alert);
	}
	
	function reset() {
		me.mAlerts = [];
	}
	
	function fromDictionary(serializedAlerts) {		
		me.mAlerts = new [serializedAlerts.size()];
		for (var i = 0; i < serializedAlerts.size(); i++) {
			me.mAlerts[i] = Alert.fromDictionary(serializedAlerts[i]);
		}
	}
	
	function toDictionary() {
		var serializedAlerts = new [me.mAlerts.size()];
		for (var i = 0; i < me.mAlerts.size(); i++) {
			serializedAlerts[i] = me.mAlerts[i].toDictionary();
		}
		return serializedAlerts;
	}
	
	function get(index) {
		return me.mAlerts[index];
	}
	
	function set(index, alert) {
		me.mAlerts[index] = alert;
	}
	
	function count() {
		return me.mAlerts.size();
	}
}

class Alert {
	function initialize() {
		me.reset();
	}
	static function fromDictionary(loadedSessionDictionary) {	
		var alert = new Alert();
		alert.type = loadedSessionDictionary["type"];
		alert.time = loadedSessionDictionary["time"];
		alert.color = loadedSessionDictionary["color"];
		alert.vibePattern = loadedSessionDictionary["vibePattern"];
		return alert;
	}
	
	function toDictionary() {
		return {
			"type" => me.type,
			"time" => me.time,
			"color" => me.color,
			"vibePattern" => me.vibePattern
		};
	}
	
	function reset() {
		me.type = IntervalAlertType.OneOff;
		me.time = 60 * 5;
		me.color = Gfx.COLOR_RED;
		me.vibePattern = VibePattern.ShorterContinuous;
	}		
		
	function getAlertPercentageTimes(sessionTime) {
		var percentageTime = me.time.toDouble() / sessionTime.toDouble();
		if (me.type == IntervalAlertType.OneOff) {
			return [percentageTime];
		}
		else {			
			var executionsCount = sessionTime / me.time;
			var result = new [executionsCount];
			for (var i = 0; i < executionsCount; i++) {
				result[i] = percentageTime * (i + 1);
			}
			return result;
		}		 
	}	
		
	var type;
	var time;//in seconds
	var color;
	var vibePattern;
}