class_name LatusWeed extends Weed

var type := Game_Enums.Weeds.LATUS

func fully_stretched():
	if(abs(stretched_vector.x) > abs(stretched_vector.y * 1.5)):
		check_kill(true)
	else:
		check_kill(false)
	super()
	
func cut():
	super()
	check_kill(false)
