extends Area2D
# since sprite extends area2d

export (float) var speed = 200;
#makes the variable avaliable to child processes
#defines bulelt speed
export (float) var lifetime = 10.00;
#how long the bullet lasts
export (Vector2) var velocity = Vector2();
#fixed velocity, different from using rotation
export (bool) var use_velocity;
#choose whether to use rotation velocity or fixed velocity
export var isHostile = false;
export var isHelpful = true;
export var colorValue = "";
export var shaping = "";
export var topheavy = false;
#other boolean/string attributes in order to change bullet attributes

onready var animation_player := $AnimationPlayer

func _ready():
  $Timer.start(lifetime);
  coloring();
  shaping();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if use_velocity:
        position += velocity.normalized() * speed * delta;
    else:
        position += Vector2(cos(rotation), -sin(rotation)) * speed * delta;
    
    if topheavy:
       animation_player.play("rotate");
#vector2 represents the positioning of an object in a 2d environment, measure velocity
#rotation attribute comes from

func coloring():
   if colorValue == "green":
     $Smoothing2D/Sprite.modulate = "#479318";
   elif colorValue == "white":
     $Smoothing2D/Sprite.modulate = "#ffffff";    
   else:
     pass

func shaping():
    if shaping == "oval":
     $Smoothing2D/Sprite.scale = Vector2(0.05,0.1);
    else:
      pass
    
func _on_Timer_timeout():
   queue_free();
#destroy object once timer reaches 0
    
func _on_Bullet_body_entered(body):
    if body.name == "Player" && isHostile == true :
        body.take_damage();

func _on_Bullet_area_entered(area):
    if area.name == "Enemy" && isHelpful == true :
        area.queue_free();
