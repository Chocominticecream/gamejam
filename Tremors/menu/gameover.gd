extends Node2D
var is_paused = false setget setgameover

func setgameover(score):
    is_paused = !is_paused
    get_tree().paused = is_paused
    get_node("finalscore").text = "Score: " + str(score)
    visible = is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _on_restart_pressed():
    self.is_paused = false;
    get_tree().reload_current_scene()
