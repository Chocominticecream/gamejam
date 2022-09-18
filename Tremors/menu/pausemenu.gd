extends Node2D
var is_paused = false setget set_is_paused
var numpadtoggle = false
# Called when the node enters the scene tree for the first time.

func set_is_paused(value):
  if get_node("/root/Node2D/grid").gameoverval == false:
    is_paused = value;
    get_tree().paused = is_paused
    visible = is_paused
    
func _unhandled_input(event):
    if event.is_action_pressed("pause"):
       self.is_paused = !is_paused
    
func _ready():
    pass # Replace with function body.
 

func _on_CheckButton_toggled(button_pressed):
    numpadtoggle = !numpadtoggle
    get_node("/root/Node2D/Player").controlnum = numpadtoggle
    if numpadtoggle == false:
       get_node("/root/Node2D/controls").text = "WASD\nor arrow keys\nto move!\npress spacebar\nto drop!"
    else:
       get_node("/root/Node2D/controls").text = "Numpad 1-7\nto move!\npress spacebar\nto drop!"
func _on_resume_pressed():
    self.is_paused = false
