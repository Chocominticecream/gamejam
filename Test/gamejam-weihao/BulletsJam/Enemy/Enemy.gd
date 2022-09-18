extends Area2D

var motion = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _process(delta):
    if get_tree().root.get_child(0).has_node('Player'):
      var Player = get_parent().get_node("Player")
    
      global_position += (Player.global_position - global_position).normalized() * 2.5
    
      look_at(Player.global_position)
    
    else:
      pass

func _on_Enemy_body_entered(body):
     if body.name == "Player" :
        body.take_damage();
        queue_free();

