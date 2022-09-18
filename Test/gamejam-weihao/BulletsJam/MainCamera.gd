#extends Camera2D
#
#export (NodePath) var TargetNodePath = null;
#export (float) var lerp_speed = 0.1
#onready var targetnode = get_node(TargetNodePath)
#var pos_x : int
#var pos_y : int
#
#func _ready():
#    self.global_position = targetnode.global_position
#
#func _process(delta):
#    var smooth_stabilizer = 1 - pow(lerp_speed, delta)
#    pos_x = int(lerp(self.global_position.x, targetnode.global_position.x, lerp_speed))
#    pos_y = int(lerp(self.global_position.y, targetnode.global_position.y, lerp_speed))
#    self.global_position = Vector2(pos_x, pos_y)
