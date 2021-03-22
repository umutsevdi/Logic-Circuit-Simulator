extends Node2D
const TYPE = "Clock"
var value=0
func _ready():
	_on_CheckButton_toggled(false)
func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		value=1	
		$Outputs/Output.SetValue(value)
	else:
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
	
func _on_Timer_timeout():
	 _on_CheckButton_toggled(1-value)
	
func _on_SpinBox_value_changed(cycle):
	if cycle!=0:
		get_node("Timer").wait_time=1/cycle
	else:	$SpinBox.cycle=1
