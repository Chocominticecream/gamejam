extends Node2D

#grid variables
export (int) var width = 7;
export (int) var height = 6;
export (int) var x_start = 150;
export (int) var y_start = 650;
export (int) var offset = 100;

var possiblepieces = [
    preload("res://tokenpiece/bluetoken.tscn")
   ];
var allpieces = [];
# Called when the node enters the scene tree for the first time.
func _ready():
    allpieces = make2DArray();
    print(allpieces);

#create2d array
func make2DArray():
    var array = [];
    for i in width:
        array.append([]);
    return array;

func grid_to_pixel(column, row):
    var new_x = x_start + offset * column;
    var new_y = y_start + -offset * row;
    return Vector2(new_x, new_y);
    
func match_at(i,j, color):
  if i > 1:
     if allpieces[i-1][j] != null && allpieces[i-2][j] != null:
        if allpieces[i-1][j].color == color && allpieces[i-2][j].color == color:
            return true;
  if j > 1:
     if allpieces[i][j-1] != null && allpieces[i][j-2] != null:
        if allpieces[i][j-1].color == color && allpieces[i][j-2].color == color:
            return true;
            
func findmatches(currentheight):
    for i in width:
        for j in currentheight+1:
              if allpieces[i][j] != null:
                 print(allpieces[i][j].color)
#                  var current = allpieces[i][j].color;
#                  if i > 1 && i < width-1:
#                      if allpieces[i-1][j] != null && allpieces[i+1][j] != null:
#                          if allpieces[i-1][j].color == current && allpieces[i+1][j].color == current:
#                             allpieces[i][j].dim();
#                             allpieces[i+1][j].dim();
#                             allpieces[i-1][j].dim();
#                             allpieces[i][j].matched = true;
#                             allpieces[i+1][j].matched = true;
#                             allpieces[i-1][j].matched = true;
                            

func ontokendrop(tokenpos):
     #reminder to randomise this
     var piece = possiblepieces[0].instance()
     if len(allpieces[tokenpos]) < height:
        add_child(piece);
        allpieces[tokenpos].append(piece);
        piece.position = get_node("/root/Node2D/Player").get_position();
        #piece.position = grid_to_pixel(tokenpos, len(allpieces[tokenpos])-1);
        #tweening
        piece.move(grid_to_pixel(tokenpos, len(allpieces[tokenpos])-1));
        #find match
        findmatches(len(allpieces[tokenpos]));
