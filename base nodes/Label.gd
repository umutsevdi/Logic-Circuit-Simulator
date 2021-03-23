extends Node2D
const TYPE = "Label"
func CreateNode():
	UIHandler.CreateUI_variable(self)
	Move.MoveStart(true,self)

func _on_Gate_button_down():
	if Move.create:
		Move.hold=false
	else:
		Move.MoveStart(false,self)

func _on_Gate_button_up():
	Move.hold=false
