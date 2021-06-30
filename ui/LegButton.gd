extends CheckButton



func _on_Button_toggled(button_pressed):
	get_node("../../TabContainer").visible=button_pressed
