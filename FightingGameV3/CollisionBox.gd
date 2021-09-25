extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0
