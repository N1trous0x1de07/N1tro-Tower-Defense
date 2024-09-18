extends Node3D

@export var tile_straight:PackedScene
@export var tile_corner:PackedScene

@export var map_length:int = 16
@export var map_height:int = 9 

var _pg:PathGenerator


# Called when the node enters the scene tree for the first time.
func _ready():
	_pg = PathGenerator.new(map_length, map_height)
	_display_path()

func _display_path():
	var _path:Array[Vector2i] = _pg.generate_path()

	while _path.size() < 35:
		_path = _pg.generate_path()

	print(_path)
	for element in _path:
		var tile_score:int = _pg.get_tile_score(element)
		print(tile_score)
		var tile:Node3D = tile_straight.instantiate()
		add_child(tile)
		tile.global_position = Vector3(element.x, 0, element.y)




