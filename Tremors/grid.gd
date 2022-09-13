extends Node2D

# position x 130 y 135
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
        #for j in height:
            #array[i].append(null);
    return array;

func grid_to_pixel(column, row):
    var new_x = x_start + offset * column;
    var new_y = y_start + -offset * row;
    return Vector2(new_x, new_y);

func ontokendrop(tokenpos):
     #reminder to randomise this
     var piece = possiblepieces[0].instance()
     if len(allpieces[tokenpos]) < height:
        add_child(piece);
        allpieces[tokenpos].append(piece);
        piece.position = grid_to_pixel(tokenpos, len(allpieces[tokenpos])-1);
