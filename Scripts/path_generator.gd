extends Object
class_name PathGenerator

var _grid_length:int = 16
var _grid_height:int = 9
var _loop_count:int

var _path: Array[Vector2i]

func _init(length:int, height:int):
	_grid_length = length
	_grid_height = height

func generate_path(add_loops:bool = false):
	_path.clear()
	_loop_count = 0
	randomize()

	var x = 0
	var y = int(_grid_height/2.0)

	while x < _grid_length:
		if not _path.has(Vector2i(x,y)):
			_path.append(Vector2i(x,y))
		
		var choice:int = randi_range(0,2)

		if choice == 0 or x % 2 == 0 or x == _grid_length-1:
			x += 1
		elif choice == 1 and y < _grid_height-2 and not _path.has(Vector2i(x,y+1)):
			y += 1
		elif choice == 2 and y > 1 and not _path.has(Vector2i(x,y-1)):
			y -= 1
	if add_loops:
		_add_loops()

	return _path

##used to evaluate path positions basd on a given value. Max is 15.
func get_tile_score(index:int) -> int:
	var score:int = 0
	var x = _path[index].x
	var y = _path[index].y

	score += 1 if _path.has(Vector2i(x,y-1)) else 0
	score += 2 if _path.has(Vector2i(x+1,y)) else 0
	score += 4 if _path.has(Vector2i(x,y+1)) else 0
	score += 8 if _path.has(Vector2i(x-1,y)) else 0

	return score

func get_path() -> Array[Vector2i]:
	return _path

func _add_loops():
	#checks loop availability
	var loops_generated:bool = true

	#Keep on goin until no loops are available
	while loops_generated:
		loops_generated = false
		for i in range(_path.size()):
			var loop:Array[Vector2i] = _is_loop_option(i)
			#if loops size > 0, then isloopoption found loop
			#Add it to the Array!
			if loop.size() > 0:
				loops_generated = true 
				for j in range(loop.size()):
					_path.insert(i+1+j, loop[j])
##For given index in path, evaluate whether loops can be generated around it
func _is_loop_option(index:int) -> Array[Vector2i]:
	var x: int = _path[index].x
	var y: int = _path[index].y
	var return_path:Array[Vector2i]

	#Yellow
	if (x < _grid_length-1 and y > 1
		and _tile_loc_free(x, y-3) and _tile_loc_free(x+1, y-3) and _tile_loc_free(x+2, y-3)		
		and _tile_loc_free(x-1, y-2) and _tile_loc_free(x, y-2) and _tile_loc_free(x+1, y-2) and _tile_loc_free(x+2, y-2) and _tile_loc_free(x+3, y-2)
		and _tile_loc_free(x-1, y-1) and _tile_loc_free(x, y-1) and _tile_loc_free(x+1, y-1) and _tile_loc_free(x+2, y-1) and _tile_loc_free(x+3, y-1)
		and _tile_loc_free(x+1,y) and _tile_loc_free(x+2,y) and _tile_loc_free(x+3,y)
		and _tile_loc_free(x+1,y+1) and _tile_loc_free(x+2,y+1)):
		return_path = [Vector2i(x+1,y), Vector2i(x+2,y), Vector2i(x+2,y-1), Vector2i(x+2,y-2), Vector2i(x+1,y-2), Vector2i(x,y-2), Vector2i(x,y-1)]

		if _path[index-1].y > y:
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

		if _path[index-1].x > x:
			return_path.reverse()

		_loop_count += 1
		return_path.append(Vector2i(x,y))
	#Red
	elif (x < _grid_length-1 and y < _grid_height-2
			and _tile_loc_free(x, y+3) and _tile_loc_free(x+1, y+3) and _tile_loc_free(x+2, y+3)		
			and _tile_loc_free(x+1, y-1) and _tile_loc_free(x+2, y-1)
			and _tile_loc_free(x+1, y) and _tile_loc_free(x+2, y) and _tile_loc_free(x+3, y)
			and _tile_loc_free(x-1, y+1) and _tile_loc_free(x, y+1) and _tile_loc_free(x+2, y+1) and _tile_loc_free(x+3, y+1)
			and _tile_loc_free(x-1, y+2) and _tile_loc_free(x, y+2) and _tile_loc_free(x+1, y+2) and _tile_loc_free(x+2, y+2) and _tile_loc_free(x+3, y+2)):
		return_path = [Vector2i(x+1,y), Vector2i(x+2,y), Vector2i(x+2,y+1), Vector2i(x+2,y+2), Vector2i(x+1,y+2), Vector2i(x,y+2), Vector2i(x,y+1)]

		if _path[index-1].y < y:
			return_path.reverse()
		
		_loop_count += 1
		return_path.append(Vector2i(x,y))
	# Brown
	elif (x > 2 and y < _grid_height-2
			and _tile_loc_free(x, y+3) and _tile_loc_free(x-1, y+3) and _tile_loc_free(x-2, y+3)
			and _tile_loc_free(x-1, y-1) and _tile_loc_free(x-2, y-1)
			and _tile_loc_free(x-1, y) and _tile_loc_free(x-2, y) and _tile_loc_free(x-3, y)
			and _tile_loc_free(x+1, y+1) and _tile_loc_free(x, y+1) and _tile_loc_free(x-2, y+1) and _tile_loc_free(x-3, y+1)
			and _tile_loc_free(x+1, y+2) and _tile_loc_free(x, y+2) and _tile_loc_free(x-1, y+2) and _tile_loc_free(x-2, y+2) and _tile_loc_free(x-3, y+2)):
		return_path = [Vector2i(x,y+1), Vector2i(x,y+2), Vector2i(x-1,y+2), Vector2i(x-2,y+2), Vector2i(x-2,y+1), Vector2i(x-2,y), Vector2i(x-1,y)]

		if _path[index-1].x > x:
			return_path.reverse()
		
		_loop_count += 1
		return_path.append(Vector2i(x,y))
		
	return return_path

##returns true if therre is a path tile at the xy coordinate
func _tile_loc_taken(x: int, y: int) -> bool:
	return _path.has(Vector2i(x,y))

##Returns true if no path tile at xy coordinate
func _tile_loc_free(x: int, y: int) -> bool:
	return not _path.has(Vector2i(x,y))

##Returns the number of loops currently in path
func get_loop_count() -> int:
	return _loop_count

##Returns the Vector2i path tile at the given index
func get_path_tile(index:int) -> Vector2i:
	return _path[index]