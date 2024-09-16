extends Node3D

@export var map_length:int = 16
@export var map_height:int = 9 


# Called when the node enters the scene tree for the first time.
func _ready():
	var pg = PathGenerator.new(map_length, map_height)
	print(pg.generate_path())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
