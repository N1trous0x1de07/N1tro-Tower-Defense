extends Object
class_name PathGenerator

var _grid_length:int = 16
var _grid_height:int = 9

var _path: Array[Vector2i]

func _init(length:int, height:int):
	_grid_length = length
	_grid_height = height

func generate_path():
	_path.clear()

	var x = 0
	var y = int(_grid_height/2)

	while x < _grid_length:
		_path.append(Vector2i(x,y))
		var choice:int = randi_range(0,2)
		x += 1

	return _path
