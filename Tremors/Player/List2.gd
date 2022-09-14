extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var buttonIsPressed = false
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	var button = Button.new()
	button.text = "2"
	button.connect("pressed", self, "_button_pressed")
	add_child(button)
	add_child(button) # Replace with function body.
func _button_pressed():
	rng.randomize()
	var my_rand_number = rng.randi_range(0,5) # Replace with function body.
	var Colors = [Color(0,0,1,1),
					Color(0,1,0,1),
					Color(0,1,1,1),
					Color(1,0,0,1),
					Color(1,0,1,1),
					Color(1,1,0,1)] 
	modulate = Colors[my_rand_number]
	return my_rand_number

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
