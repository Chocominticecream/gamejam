extends Label

export (int) var time = 3
signal timeup(timings)
export (bool) var open = true;

func _ready():
    $Timer.start(time);
    #connect("timeup", get_node("/root/Node2D/Player/GUI/Shop"), "openshop")
    
func _process(delta):
     time -= delta
     time = fmod(time, 60)
     var time_passed = "Time left til next wave: %02d" % [time]
     text = time_passed

func _on_Timer_timeout():
    emit_signal("timeup", open)
    time = 3
