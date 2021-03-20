extends Node2D
const TYPE = "Variable"
var value=0
func _ready():
	_on_CheckButton_toggled(false)
func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		value=1	
		$CheckButton.text="On"
		$Outputs/Output.SetValue(value)
	else:
		$CheckButton.text="Off"
		value=0
		$Outputs/Output.SetValue(value)
		
func CreateNode():
	UIHandler.CreateUI_variable(self)
	Move.MoveStart(true)


func _on_Gate_button_down():
	UIHandler.CreateUI_variable(self)
	Move.MoveStart(false)

func _on_Gate_button_up():
	Move.hold=false
