extends Control

var is_paused = false setget set_is_paused
onready var bullets = get_node("../../../Bulletspawner")
onready var space = get_node("../../../Bulletsspace")
export var space_scene: PackedScene;

#Coding to do list:
#
#optimise and change appropriate values of instance variables to enum 
#implement switch statements
#reimplement the wave system

#func openshop(timings):
#     var bullets = get_node("/root/Node2D/Bulletspawner")
#     var arr = bullets.spawned_bullets
#     for item in arr:
#         queue_free()
#     self.is_paused = true

func set_is_paused(value):
    for n in space.get_children():
       n.queue_free()
    is_paused = value;
    get_tree().paused = is_paused
    visible = is_paused
    
func _unhandled_input(event):
    if event.is_action_pressed("pause"):
     self.is_paused = !is_paused

func _on_Resume_pressed():
    self.is_paused = false

func _on_Quit_pressed():
    get_tree().quit()

#pausing function

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.



func _on_BuyHive_pressed():
    self.is_paused = false
    
