extends ParallaxBackground

export (float) var scrollingspeed = 100

func _process(delta):
    scroll_offset.y += scrollingspeed * delta
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
