extends Node2D

export var bullet_scene: PackedScene;
export var min_rotation = 0;
export var max_rotation = 360;
export var number_of_bullets = 8;
export var is_random = false;
export var is_parent = false;
export var is_manual = false;
export var spawn_rate = 0.4;
export (bool) var spawncheck = true;
#these 3 variables below are instantiated into packedscene when an instance of bullet is created
export var bullet_speed = 5;
export var bullet_velocity = 5;
export var bullet_lifetime= 5;
export (bool) var hostility = true;
export (bool) var use_velocity = false;
export (bool) var helpful = false;

var rotations = [];
onready var spawned_bullets = get_node("../").container

func _ready():
     $Timer.wait_time = spawn_rate
#set timer to spawn rate
     $Timer.start()
 #start the timer

func random_rotations():
   rotations = [];
   #set the rotations to empty so that it can be re edited by the functions
   for _i in range(0, number_of_bullets):
      rotations.append(rand_range(min_rotation, max_rotation));

func distributed_rotations():
   rotations = [];
   for i in range(0, number_of_bullets):
      var fraction = float(i) / float(number_of_bullets);
      #MUST float or it would only fire in one direction
      var difference = max_rotation - min_rotation
      rotations.append(fraction * difference + min_rotation);
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_bullets():
    if(is_random):
        random_rotations();
    else:
        distributed_rotations();
    #this changes the rotation attribute in the bullet
    
    spawned_bullets = [];
    if (spawncheck == true):
      for i in range(0, number_of_bullets):
        var bullet = bullet_scene.instance();
        #instantiates a bullet using .instance()
        
        spawned_bullets.append(bullet);
        #add the bullets to the array
        get_node("../Bulletsspace").add_child(spawned_bullets[i]);
        #add the bullets as a child to the current node/scene
        
        spawned_bullets[i].rotation_degrees = rotations[i];
        spawned_bullets[i].speed = bullet_speed;
        spawned_bullets[i].velocity = bullet_velocity;
        spawned_bullets[i].global_position = global_position;
        #position on the screen
        spawned_bullets[i].use_velocity = use_velocity;
        spawned_bullets[i].lifetime = bullet_lifetime;
        spawned_bullets[i].isHostile = hostility;
        spawned_bullets[i].isHelpful = helpful;
        
        #if (log_to_console):
            #print("Bullet" + str(i) + "@" + str(rotations[i]) + "deg")

func _on_Timer_timeout():
    if !is_manual:
        spawn_bullets();
