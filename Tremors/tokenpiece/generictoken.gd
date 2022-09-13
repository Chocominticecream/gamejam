extends Node2D
var TweenNode;

func _ready():
    TweenNode = get_node("moveTween")
    
func move(target):
    TweenNode.interpolate_property(self, "position", get_position(), target, 1.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT);
    TweenNode.start();
# Called when the node enters the scene tree for the first time.

