extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var square_path = preload("res://square-128.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	 # Replace with function body.
	var sq = square_path.instance()
	add_child(sq)
	sq.position.x = 50
	sq.position.y = 50
	sq.scale.x = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
