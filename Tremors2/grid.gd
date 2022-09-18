extends Node2D

#grid variables
export (int) var width = 7;
export (int) var height = 6;
export (int) var x_start = 150;
export (int) var y_start = 650;
export (int) var offset = 100;
export (int) var value = 0;

#non adjustable variables
#signal
signal colorchange(color)
signal gameover(score)

#preload the tokens into an array
var possiblepieces = [
    preload("res://tokenpiece/bluetoken.tscn"),
    preload("res://tokenpiece/redtoken.tscn"),
    preload("res://tokenpiece/yellowtoken.tscn"),
    preload("res://tokenpiece/greentoken.tscn"),
    preload("res://tokenpiece/purpletoken.tscn")
   ];
#this array stores all pieces
var allpieces = [];
#this array stores the single instanced piece held by the player
var storedpiece = [];
var rng = RandomNumberGenerator.new()
var rngno2 = RandomNumberGenerator.new()
var abletogen = true
var gameoverval = false

#combo and score checks
var cascade = 1
var score = 0
var tokensdestroyed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    allpieces = make2DArray();
    print(allpieces);
    #test signal
    connect("colorchange", get_node("/root/Node2D/colorcanvas"), "colorchanger")
    connect("gameover", get_node("/root/Node2D/gameover/gameover"), "setgameover")

#create2d array
func make2DArray():
    var array = [];
    for i in width:
        array.append([]);
    return array;

#convert array location to position
func grid_to_pixel(column, row):
    var new_x = x_start + offset * column;
    var new_y = y_start + -offset * row;
    return Vector2(new_x, new_y);
    
#testing code
func match_at(i,j, color):
    if i > 1:
        if allpieces[i-1][j] != null && allpieces[i-2][j] != null:
            if allpieces[i-1][j].color == color && allpieces[i-2][j].color == color:
                return true;
    if j > 1:
        if allpieces[i][j-1] != null && allpieces[i][j-2] != null:
            if allpieces[i][j-1].color == color && allpieces[i][j-2].color == color:
                return true;
            
#find matches           
func findmatches():
    for i in width:
        for j in len(allpieces[i]):
            if allpieces[i][j] != null:  
                 var current = allpieces[i][j].color;
                 #match right and left
                 if i >= 1 && i < width-1:
                    if len(allpieces[i-1]) > j && len(allpieces[i+1]) > j:
                      #check for null
                      if allpieces[i-1][j] != null &&  allpieces[i+1][j] != null:
                        #compare colors
                        if allpieces[i-1][j].color == current && allpieces[i+1][j].color == current:
                             allpieces[i][j].dim();
                             allpieces[i+1][j].dim();
                             allpieces[i-1][j].dim();
                             allpieces[i][j].matched = true;
                             allpieces[i+1][j].matched = true;
                             allpieces[i-1][j].matched = true;
                            
                 #match up and down
                 if j >= 1 && j < height-1:
                    if j+1 < len(allpieces[i]):
                      if allpieces[i][j+1] != null &&  allpieces[i][j-1] != null:
                        if allpieces[i][j+1].color == current && allpieces[i][j-1].color == current:
                             allpieces[i][j].dim();
                             allpieces[i][j+1].dim();
                             allpieces[i][j-1].dim();
                             allpieces[i][j].matched = true;
                             allpieces[i][j+1].matched = true;
                             allpieces[i][j-1].matched = true;
                             
                 #match diagonals pt 1
                 if i >= 1 && i < width-1 && j >= 1 && j < height-1:
                     if len(allpieces[i-1]) > j-1 && len(allpieces[i+1]) > j+1:
                        if allpieces[i+1][j+1] != null &&  allpieces[i-1][j-1] != null:
                          if allpieces[i+1][j+1].color == current && allpieces[i-1][j-1].color == current:
                             allpieces[i][j].dim();
                             allpieces[i+1][j+1].dim();
                             allpieces[i-1][j-1].dim();
                             allpieces[i][j].matched = true;
                             allpieces[i+1][j+1].matched = true;
                             allpieces[i-1][j-1].matched = true;
                 #match diagonals pt 2
                 if i >= 1 && i < width-1 && j >= 1 && j < height-1:
                     if len(allpieces[i-1]) > j+1 && len(allpieces[i+1]) > j-1:
                        if allpieces[i+1][j-1] != null &&  allpieces[i-1][j+1] != null:
                          if allpieces[i+1][j-1].color == current && allpieces[i-1][j+1].color == current:
                             allpieces[i][j].dim();
                             allpieces[i+1][j-1].dim();
                             allpieces[i-1][j+1].dim();
                             allpieces[i][j].matched = true;
                             allpieces[i+1][j-1].matched = true;
                             allpieces[i-1][j+1].matched = true;
                 
#function for token dropping
func ontokendrop(tokenpos):
   if abletogen == false:
     var piece = storedpiece[0] 
     if len(allpieces[tokenpos]) < height+1:
        #append piece to grid
        allpieces[tokenpos].append(piece);
        #tweening
        piece.move(grid_to_pixel(tokenpos, len(allpieces[tokenpos])-1));
        #after tweening, change parent and position
        #small delay then find match
        yield(get_tree().create_timer(0.7), "timeout")
        findmatches();
        if gameovercheck() == true:
           gameoverval = true
           emit_signal("gameover", score)
           return 0
    
        #normal drop turn
        #token destruction loop, check false checks if there are avaliable destructible tokens
        while checkfalse() == true:
             #short delays to simulate token falling
             #this timer is a reference and is destroyed once its executed!
             yield(get_tree().create_timer(0.1), "timeout")
             removetokens();
             yield(get_tree().create_timer(0.1), "timeout")
             updatepositions();
             findmatches();
             cascade += 1
        cascade = 1
        
        #on random drop
        randomdrop();
        yield(get_tree().create_timer(0.7), "timeout")
        findmatches();
        gameovercheck();
        if gameovercheck() == true:
           gameoverval = true
           emit_signal("gameover", score)
           return 0
        
        while checkfalse() == true:
             #short delays to simulate token falling
             #this timer is a reference and is destroyed once its executed!
             yield(get_tree().create_timer(0.1), "timeout")
             removetokens();
             yield(get_tree().create_timer(0.1), "timeout")
             updatepositions();
             findmatches();
             cascade += 1
        cascade = 1
        
        storedpiece.clear()
        yield(get_tree().create_timer(1.0), "timeout")
        abletogen = true;
        get_node("/root/Node2D/Player").inputdelay = 0 
        #button enabler
        get_node("/root/Node2D/Button").disabled = false
        get_node("/root/Node2D/Button/debugblue").disabled = false
        get_node("/root/Node2D/Button/debugred").disabled = false
        get_node("/root/Node2D/Button/debugyellow").disabled = false
        get_node("/root/Node2D/Button/debuggreen").disabled = false
        get_node("/root/Node2D/Button/debugpurple").disabled = false
    
#function for updating piece position
func onplayermove(positioner):
     #weakref checks if piece is freed
     if storedpiece.size() > 0 && weakref(storedpiece[0]).get_ref():
        storedpiece[0].position.x = 150 + positioner*100
        
#update tokens and simulate falling of tokens
func updatepositions():
     for i in width:
        for j in len(allpieces[i]):             
               allpieces[i][j].position =  grid_to_pixel(i, j); 
            
#destroy tokens   
func removetokens():
    #deepcopy
    var dummy = []
    for i in width:
        dummy.append([])
        for j in range (len(allpieces[i])):
            dummy[i].append(allpieces[i][j].matched)
    
    for i in width:
        for j in range(len(dummy[i])-1, -1 , -1):
            if dummy[i][j] == true:
                allpieces[i][j].queue_free()
                allpieces[i].remove(j)
                score += cascade * 100
                get_node("/root/Node2D/scorecanvas/score").text = "Score: " + str(score)
                
#checks if theres any matched true tokens, if there is none end the token destruction loop               
func checkfalse():
    for i in width:
        for j in len(allpieces[i]):
            if allpieces[i][j].matched == true:
                return true;
    return false;
    
func gameovercheck():
    for i in width:
        if len(allpieces[i]) > height:
            return true
    return false
    
#random token drop
func randomdrop():
    rng.randomize()
    rngno2.randomize()
    var colordrop = rng.randi_range(0,4)
    var posdrop = rng.randi_range(0,6)
    while len(allpieces[posdrop]) == height+1:
        posdrop = rng.randi_range(0,6)
    if len(allpieces[posdrop]) < height+1:
       var piece = possiblepieces[colordrop].instance()
       add_child(piece)
       piece.position.x = 150 + (posdrop * 100)
       piece.position.y = -100
       allpieces[posdrop].append(piece);
       piece.move(grid_to_pixel(posdrop, len(allpieces[posdrop])-1));

#generator button                
func _on_Button_pressed():
     rng.randomize()
     value = rng.randi_range(0,4)
     emit_signal("colorchange", possiblepieces[value].instance())
     get_node("/root/Node2D/Button").disabled = true
     get_node("/root/Node2D/Button/debugblue").disabled = true
     get_node("/root/Node2D/Button/debugred").disabled = true
     get_node("/root/Node2D/Button/debugyellow").disabled = true
     get_node("/root/Node2D/Button/debuggreen").disabled = true
     get_node("/root/Node2D/Button/debugpurple").disabled = true
     abletogen = false;
     
     #spawn piece at player pos
     var piece = possiblepieces[value].instance()
     add_child(piece);
     piece.position = get_node("/root/Node2D/Player").get_position();
     storedpiece.append(piece);

#debug buttons with boilerplate code
func _on_debugblue_pressed():
     get_node("/root/Node2D/Button").disabled = true
     get_node("/root/Node2D/Button/debugblue").disabled = true
     get_node("/root/Node2D/Button/debugred").disabled = true
     get_node("/root/Node2D/Button/debugyellow").disabled = true
     get_node("/root/Node2D/Button/debuggreen").disabled = true
     get_node("/root/Node2D/Button/debugpurple").disabled = true
     abletogen = false;
    
     var piece = possiblepieces[0].instance()
     add_child(piece);
     piece.position = get_node("/root/Node2D/Player").get_position();
     storedpiece.append(piece);
     emit_signal("colorchange", possiblepieces[0].instance())

func _on_debugred_pressed():
     get_node("/root/Node2D/Button").disabled = true
     get_node("/root/Node2D/Button/debugblue").disabled = true
     get_node("/root/Node2D/Button/debugred").disabled = true
     get_node("/root/Node2D/Button/debugyellow").disabled = true
     get_node("/root/Node2D/Button/debuggreen").disabled = true
     get_node("/root/Node2D/Button/debugpurple").disabled = true
     abletogen = false;
    
     var piece = possiblepieces[1].instance()
     add_child(piece);
     piece.position = get_node("/root/Node2D/Player").get_position();
     storedpiece.append(piece);
     emit_signal("colorchange", possiblepieces[1].instance())
    
func _on_debugyellow_pressed():
     get_node("/root/Node2D/Button").disabled = true
     get_node("/root/Node2D/Button/debugblue").disabled = true
     get_node("/root/Node2D/Button/debugred").disabled = true
     get_node("/root/Node2D/Button/debugyellow").disabled = true
     get_node("/root/Node2D/Button/debuggreen").disabled = true
     get_node("/root/Node2D/Button/debugpurple").disabled = true
     abletogen = false;
    
     var piece = possiblepieces[2].instance()
     add_child(piece);
     piece.position = get_node("/root/Node2D/Player").get_position();
     storedpiece.append(piece);
     emit_signal("colorchange", possiblepieces[2].instance())


func _on_debuggreen_pressed():
     get_node("/root/Node2D/Button").disabled = true
     get_node("/root/Node2D/Button/debugblue").disabled = true
     get_node("/root/Node2D/Button/debugred").disabled = true
     get_node("/root/Node2D/Button/debugyellow").disabled = true
     get_node("/root/Node2D/Button/debuggreen").disabled = true
     get_node("/root/Node2D/Button/debugpurple").disabled = true
     abletogen = false;
    
     var piece = possiblepieces[3].instance()
     add_child(piece);
     piece.position = get_node("/root/Node2D/Player").get_position();
     storedpiece.append(piece);
     emit_signal("colorchange", possiblepieces[3].instance())


func _on_debugpurple_pressed():
     get_node("/root/Node2D/Button").disabled = true
     get_node("/root/Node2D/Button/debugblue").disabled = true
     get_node("/root/Node2D/Button/debugred").disabled = true
     get_node("/root/Node2D/Button/debugyellow").disabled = true
     get_node("/root/Node2D/Button/debuggreen").disabled = true
     get_node("/root/Node2D/Button/debugpurple").disabled = true
     abletogen = false;
    
     var piece = possiblepieces[4].instance()
     add_child(piece);
     piece.position = get_node("/root/Node2D/Player").get_position();
     storedpiece.append(piece);
     emit_signal("colorchange", possiblepieces[4].instance())

#polish plans:
#new vector art
#fix blurriness and jaggedness if possible
#new better font
#options to toggle between numpad and arrow keys
#game over screen



