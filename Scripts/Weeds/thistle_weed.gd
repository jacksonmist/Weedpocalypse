class_name ThistleWeed extends Weed

func cut():
	super()
	check_kill(true)

func fully_stretched():
	super()
	check_kill(false)
