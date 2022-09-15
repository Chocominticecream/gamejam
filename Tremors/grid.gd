extends Node2D

#grid variables
export (int) var width = 7;
export (int) var height = 6;
export (int) var x_start = 150;
export (int) var y_start = 650;
export (int) var offset = 100;
export (int) var value = 0;

#signal
signal colorchange(color)

var possiblepieces = [
    preload("res://tokenpiece/bluetoken.tscn"),
    preload("res://tokenpiece/redtoken.tscn")
   ];
var allpieces = [];
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
    allpieces = make2DArray();
    print(allpieces);
    #test signal
    connect("colorchange", get_node("/root/Node2D/Button/colorindicator"), "colorchanger")

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
                    #check to see if current token height is lesser than the number of tokens beside it
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
                             allpieces[i][j].queue_free();
                             allpieces[i+1][j].queue_free();
                             allpieces[i-1][j].queue_free();
                             allpieces[i].remove(j);
                             allpieces[i+1].remove(j);
                             allpieces[i-1].remove(j);
                             updatepositions();
                             break
                            
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
                             allpieces[i][j].queue_free();
                             allpieces[i][j+1].queue_free();
                             allpieces[i][j-1].queue_free();
                             allpieces[i].remove(j+1);
                             allpieces[i].remove(j);
                             allpieces[i].remove(j-1);
                             updatepositions();
                             break
                            
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
                 

func ontokendrop(tokenpos):
     #delay between presses
     var piece = possiblepieces[value].instance()
     if len(allpieces[tokenpos]) < height:
        add_child(piece);
        allpieces[tokenpos].append(piece);
        piece.position = get_node("/root/Node2D/Player").get_position();
        #piece.position = grid_to_pixel(tokenpos, len(allpieces[tokenpos])-1);
        #tweening
        piece.move(grid_to_pixel(tokenpos, len(allpieces[tokenpos])-1));
        #small delay then find match
        yield(get_tree().create_timer(0.7), "timeout")
        findmatches();

func updatepositions():
     for i in width:
        for j in len(allpieces[i]):
            yield(get_tree().create_timer(0.05), "timeout")
            allpieces[i][j].position =  grid_to_pixel(i, j); 
            findmatches();

func _on_Button_pressed():
     rng.randomize()
     value = rng.randi_range(0,1)
     emit_signal("colorchange", possiblepieces[value].instance())

func _on_debugblue_pressed():
     value = 0;
     emit_signal("colorchange", possiblepieces[value].instance())

func _on_debugred_pressed():
     value = 1;
     emit_signal("colorchange", possiblepieces[value].instance())
