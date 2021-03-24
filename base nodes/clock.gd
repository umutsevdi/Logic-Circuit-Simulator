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
	Move.MoveStart(true,self)

func _on_Gate_button_down():
	if Move.create:
		Move.hold=false
	else:
		Move.MoveStart(false,self)

func _on_Gate_button_up():
	Move.hold=false
	
func _on_Timer_timeout():
	 _on_CheckButton_toggled(1-value)
	
func _on_SpinBox_value_changed(cycle):
	if cycle!=0:
		get_node("Timer").wait_time=1/cycle
	else:
		$SpinBox.value=1
		get_node("Timer").wait_time=1
		
func DeleteNode():
	if $Outputs/Output.connection:
		$Outputs/Output.emit_signal("value_changed",2)
