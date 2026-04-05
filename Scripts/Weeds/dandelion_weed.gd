class_name Dandelion extends Weed

func cut():
	super()
	check_kill(false)

func fully_stretched():
	super()
	check_kill(true)
	
func set_kill_velocity():
	var to_mouse = (get_global_mouse_position() - position).normalized()
	var speed = randf_range(0, 250)
	velocity += to_mouse * speed
	rotation_speed = randf_range(-10, 10)
	
