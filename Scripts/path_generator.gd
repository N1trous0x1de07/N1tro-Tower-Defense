extends Node
class_name PathGenerator

var _loop_count:int

var path_config:PathGeneratorConfig = preload("res://resources/basic_path_config.res")

var _path_route: Array[Vector2i]

func _init():
	generate_path(path_config.add_loops)

	while(_path_route.size() < path_config.min_path_size or _path_route.size() > path_config.max_path_size
		or _loop_count < path_config.min_loops or _loop_count > path_config.max_loops
	):
			generate_path(path_config.add_loops)


##Main work function. Generates random path left to right. Loops will be checked and added if add_loops is true.
func generate_path(add_loops:bool = false):
	_path_route.clear()
	randomize()
	_loop_count = 0

	var x = 0
	var y = int(path_config.map_height/2.0)

	while x < path_config.map_length:
		if not _path_route.has(Vector2i(x,y)):
			_path_route.append(Vector2i(x,y))

		var choice:int = randi_range(0,2)

		if choice == 0 or x < 2 or x % 2 == 0 or x == path_config.map_length-1:
			x +=1
		elif choice == 1 and y < path_config.map_height-2 and not _path_route.has(Vector2i(x,y+1)):
			y +=1
		elif choice == 2 and y > 1 and not _path_route.has(Vector2i(x,y-1)):
			y -= 1
	

	if add_loops:
		_add_loops()


	return _path_route

##used to eval where the path tiles are around given file. Max is 15._add_constant_central_force
## Score +1 if path tile above (y-1)
## Score +2 if path tile to the right (x+1)
## Score +4 if path tile below (y+1)
## Score +8 if path tile to the left (x-1)
func get_tile_score(index:int) -> int:
	var score:int = 0
	var x = _path_route[index].x
	var y = _path_route[index].y

	score += 1 if _path_route.has(Vector2i(x,y-1)) else 0
	score += 2 if _path_route.has(Vector2i(x+1,y)) else 0
	score += 4 if _path_route.has(Vector2i(x,y+1)) else 0
	score += 8 if _path_route.has(Vector2i(x-1,y)) else 0

	return score

##Returns the array of all path tiles.
func get_path_route() -> Array[Vector2i]:
	return _path_route

##returns the Vector2i path tile at given index
func get_path_tile(index:int) -> Vector2i:
	return _path_route[index]

##if loops is active, see if we can add a loop or two
func _add_loops():
	#see if we can add any loops
	var loops_generated:bool = true

	#keep generating until you cannot any more
	while loops_generated and _loop_count < path_config.max_loops:
		loops_generated = false
		for i in range(_path_route.size()):
			var loop:Array[Vector2i] = _is_loop_option(i)
			#if the loop size > 0, then _is_loops_option found loop.. so add it to the array
			if loop.size() > 0:
				loops_generated = true
				for j in range(loop.size()):
					_path_route.insert(i+1+j, loop[j])

##for given index in path eval whether loops can be generated around it
func _is_loop_option(index:int) -> Array[Vector2i]:
	var x: int = _path_route[index].x
	var y: int = _path_route[index].y
	var return_path:Array[Vector2i]

	#Yellow
	if (x < path_config.map_length-1 and y > 1
		and _tile_loc_free(x, y-3) and _tile_loc_free(x+1, y-3) and _tile_loc_free(x+2, y-3)		
		and _tile_loc_free(x-1, y-2) and _tile_loc_free(x, y-2) and _tile_loc_free(x+1, y-2) and _tile_loc_free(x+2, y-2) and _tile_loc_free(x+3, y-2)
		and _tile_loc_free(x-1, y-1) and _tile_loc_free(x, y-1) and _tile_loc_free(x+1, y-1) and _tile_loc_free(x+2, y-1) and _tile_loc_free(x+3, y-1)
		and _tile_loc_free(x+1,y) and _tile_loc_free(x+2,y) and _tile_loc_free(x+3,y)
		and _tile_loc_free(x+1,y+1) and _tile_loc_free(x+2,y+1)):
		return_path = [Vector2i(x+1,y), Vector2i(x+2,y), Vector2i(x+2,y-1), Vector2i(x+2,y-2), Vector2i(x+1,y-2), Vector2i(x,y-2), Vector2i(x,y-1)]

		if _path_route[index-1].y > y:
			return_path.reverse()
			
		_loop_count += 1
		return_path.append(Vector2i(x,y))
	#Blue
	elif (x > 2 and y > 1
			and _tile_loc_free(x, y-3) and _tile_loc_free(x-1, y-3) and _tile_loc_free(x-2, y-3)		
			and _tile_loc_free(x-1, y) and _tile_loc_free(x-2, y) and _tile_loc_free(x-3, y)
			and _tile_loc_free(x+1, y-1) and _tile_loc_free(x, y-1) and _tile_loc_free(x-2, y-1) and _tile_loc_free(x-3, y-1)
			and _tile_loc_free(x+1, y-2) and _tile_loc_free(x, y-2) and _tile_loc_free(x-1, y-2) and _tile_loc_free(x-2, y-2) and _tile_loc_free(x-3, y-2)
			and _tile_loc_free(x-1, y+1) and _tile_loc_free(x-2, y+1)):
		return_path = [Vector2i(x,y-1), Vector2i(x,y-2), Vector2i(x-1,y-2), Vector2i(x-2,y-2), Vector2i(x-2,y-1), Vector2i(x-2,y), Vector2i(x-1,y)]

		if _path_route[index-1].x > x:
			return_path.reverse()

		_loop_count += 1
		return_path.append(Vector2i(x,y))
	#Red
	elif (x < path_config.map_length-1 and y < path_config.map_height-2
			and _tile_loc_free(x, y+3) and _tile_loc_free(x+1, y+3) and _tile_loc_free(x+2, y+3)		
			and _tile_loc_free(x+1, y-1) and _tile_loc_free(x+2, y-1)
			and _tile_loc_free(x+1, y) and _tile_loc_free(x+2, y) and _tile_loc_free(x+3, y)
			and _tile_loc_free(x-1, y+1) and _tile_loc_free(x, y+1) and _tile_loc_free(x+2, y+1) and _tile_loc_free(x+3, y+1)
			and _tile_loc_free(x-1, y+2) and _tile_loc_free(x, y+2) and _tile_loc_free(x+1, y+2) and _tile_loc_free(x+2, y+2) and _tile_loc_free(x+3, y+2)):
		return_path = [Vector2i(x+1,y), Vector2i(x+2,y), Vector2i(x+2,y+1), Vector2i(x+2,y+2), Vector2i(x+1,y+2), Vector2i(x,y+2), Vector2i(x,y+1)]

		if _path_route[index-1].y < y:
			return_path.reverse()
		
		_loop_count += 1
		return_path.append(Vector2i(x,y))
	# Brown
	elif (x > 2 and y < path_config.map_height-2
			and _tile_loc_free(x, y+3) and _tile_loc_free(x-1, y+3) and _tile_loc_free(x-2, y+3)
			and _tile_loc_free(x-1, y-1) and _tile_loc_free(x-2, y-1)
			and _tile_loc_free(x-1, y) and _tile_loc_free(x-2, y) and _tile_loc_free(x-3, y)
			and _tile_loc_free(x+1, y+1) and _tile_loc_free(x, y+1) and _tile_loc_free(x-2, y+1) and _tile_loc_free(x-3, y+1)
			and _tile_loc_free(x+1, y+2) and _tile_loc_free(x, y+2) and _tile_loc_free(x-1, y+2) and _tile_loc_free(x-2, y+2) and _tile_loc_free(x-3, y+2)):
		return_path = [Vector2i(x,y+1), Vector2i(x,y+2), Vector2i(x-1,y+2), Vector2i(x-2,y+2), Vector2i(x-2,y+1), Vector2i(x-2,y), Vector2i(x-1,y)]

		if _path_route[index-1].x > x:
			return_path.reverse()
		
		_loop_count += 1
		return_path.append(Vector2i(x,y))
		
	return return_path

##returns true if there is a path tile at the x,y coordinate
func _tile_loc_taken(x: int, y: int) -> bool:
	return _path_route.has(Vector2i(x,y))

##Returns true if there is no pat tile at xy coordinate
func _tile_loc_free(x: int, y: int) -> bool:
	return not _path_route.has(Vector2i(x,y))

##returns the number of loops currently in path
func get_loop_count() -> int:
	return _loop_count

#func to_path_follow_3d() -> PathFollow3D:
#	var c3d:Curve3D = Curve3D.new()
#
#	for element in _path:
#		c3d.add_point(Vector3(element.x, 0.4, element.y))
#
#	var p3d:Path3D = Path3D.new()
##	add_child(p3d)
#	p3d.curve = c3d
#
#	var pf3d:PathFollow3D = PathFollow3D.new()
#	p3d.add_child(pf3d)
#
#	return pf3d

