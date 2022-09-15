extends KinematicBody2D

export (int) var speed = 200;
export (int) var start_hp : int = 3;
onready var hp := start_hp;

signal life_changed(player_hearts)

var can_take_damage = true;
onready var animation_player := $AnimationPlayer
onready var animation_player2 := $AnimationPlayer2

export var bulletScene: PackedScene;
export var is_parent = false;
export var bullet_speed = 5;
export var bullet_velocity = 5;
export var bullet_lifetime= 5;
export (bool) var hostility = false;
export (bool) var use_velocity = false;
export (String) var green = "white";
export (String) var oval = "oval";
export (bool) var helpful = true;
export (bool) var spin = true;
#bullet attributes

export (bool) var clamp_to_window_borders = false;

onready var screen_borders = Vector2(
   ProjectSettings.get_setting("display/window/size/width"),
   ProjectSettings.get_setting("display/window/size/height")
   );
#can get these options in Project > settings > window

func _ready():
    connect("life_changed", get_node("/root/Node2D/Player/UI/Life"), "on_player_life_changed")
    emit_signal("life_changed", start_hp)
    
func _physics_process(delta):
    #input
    look_at(get_global_mouse_position())
    $Node2D.look_at(get_global_mouse_position())
    animation_player2.play("Flight")
    
    var velocity := Vector2()
    velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    velocity = velocity.normalized();
    
    velocity = move_and_slide(velocity * speed);
    
    if Input.is_action_just_pressed("left_click"):
        shoot()
    
    #Clamp
    if clamp_to_window_borders:
         global_position = Vector2(clamp(global_position.x, 0, screen_borders.x), clamp(global_position.y, 0, screen_borders.y));
        
func take_damage():
    if(can_take_damage):
       can_take_damage = false;
       hp -= 1
       emit_signal("life_changed", hp)
       animation_player.play("Hit")
    if hp == 0:
          queue_free();
          #get_tree().change_scene("res://GameOver.tscn");
    else:
       return;
    
func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "Hit":
       can_take_damage = true;
    
func shoot():
     var bullet = bulletScene.instance();
     
     bullet.position = $Node2D/Position2D.global_position;
     bullet.rotation_degrees = -rotation_degrees;
     bullet.speed = bullet_speed;
     bullet.velocity = bullet_velocity;
        #position on the screen
     bullet.use_velocity = use_velocity;
     bullet.lifetime = bullet_lifetime;
     bullet.isHostile = hostility;
     bullet.colorValue = green;
     bullet.shaping = oval;
     bullet.isHelpful = helpful;
     bullet.topheavy = spin;
    
     if (is_parent):
        add_child(bullet);
     else:
        get_node("/root").add_child(bullet);
    

      
        

#remember that we must manuallty put the signal in first! cant just type the name of the signal!
