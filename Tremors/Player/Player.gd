extends KinematicBody2D

<<<<<<< Updated upstream
export (int) var speed = 400;
#hello World
func _physics_process(delta): #hello
	var velocity := Vector2() #type of array and is a container actually
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = velocity.normalized();
	
	velocity = move_and_slide(velocity * speed);

func _ready():
	pass # Replace with function body.
=======
export (int) var speed = 200;
export (bool) var clamp_to_window_borders = true;
#numpad position
export (int) var positioning = 0;
export (bool) var controlnum = true;

#signal
signal tokendrop(tokenpos)
signal changepiecepos(positioner);

onready var screen_borders = Vector2(
ProjectSettings.get_setting("display/window/size/width"),
ProjectSettings.get_setting("display/window/size/height")
);

func _input(event):
	if controlnum == false:
	   if Input.is_action_pressed("ui_right") and positioning < 6:
		   positioning += 1;
	   if Input.is_action_pressed("ui_left") and positioning > 0:
		   positioning -= 1;
	   self.global_position = Vector2(150 + positioning*100, self.global_position.y);
	elif controlnum == true:
	   if Input.is_action_pressed("1"):
		   positioning = 0;
	   elif Input.is_action_pressed("2"):
		   positioning = 1;
	   elif Input.is_action_pressed("3"):
		   positioning = 2;
	   elif Input.is_action_pressed("4"):
		   positioning = 3;
	   elif Input.is_action_pressed("5"):
		   positioning = 4;
	   elif Input.is_action_pressed("6"):
		   positioning = 5;
	   elif Input.is_action_pressed("7"):
		   positioning = 6;
	   self.global_position = Vector2(150 + positioning*100, self.global_position.y);
	emit_signal("changepiecepos", positioning);
	
	if Input.is_action_pressed("ui_select"):
		  emit_signal("tokendrop", positioning);
	
	get_node("indicatorlabel").text = str(positioning+1)
	
func _physics_process(delta):
# Clamp
	if clamp_to_window_borders:
	   global_position = Vector2(clamp(global_position.x, 0, screen_borders.x), clamp(global_position.y, 0, screen_borders.y));

func _ready():
	connect("tokendrop", get_node("/root/Node2D/grid"), "ontokendrop")
	connect("changepiecepos", get_node("/root/Node2D/grid"), "onplayermove")
>>>>>>> Stashed changes
