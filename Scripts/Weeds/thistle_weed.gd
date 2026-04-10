class_name ThistleWeed extends Weed

var type := Game_Enums.Weeds.THISTLE

func cut():
	super()
	check_kill(true)

func fully_stretched():
	super()
	check_kill(false)
