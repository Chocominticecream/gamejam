extends KinematicBody2D

export (int) var speed = 400;
#hello World
func _physics_process(delta):
	var velocity := Vector2() #type of array and is a container actually
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = velocity.normalized();
	
	velocity = move_and_slide(velocity * speed);
	var Colors = [Color(0,0,1,1),
					Color(0,1,0,1),
					Color(0,1,1,1),
					Color(1,0,0,1),
					Color(1,0,1,1),
					Color(1,1,0,1)] 
	modulate = Colors[randi() % Colors.size()]
func _ready():
	 pass# Replace with function body.
	
