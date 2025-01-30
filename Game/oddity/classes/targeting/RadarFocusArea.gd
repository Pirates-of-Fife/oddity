extends RadarArea

class_name RadarFocusArea

func focus_target() -> Starship:
	var min_distance : float = 10000000000
	var ship : Starship

	for t : GameEntity in entities:
		if t is Starship:
			var distance : float = (t.global_position - starship.global_position).length()

			if distance < min_distance:
				min_distance = distance
				ship = t

	print("FOCUSED " + str(ship))

	return ship
