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
	Move.MoveStart(true,self)

func _on_Gate_button_down():
	if Move.create:
		Move.hold=false
	else:
		Move.MoveStart(false,self)

func _on_Gate_button_up():
	Move.hold=false

func DeleteNode():
	if $Outputs/Output.connection:
		$Outputs/Output.emit_signal("value_changed",2)
