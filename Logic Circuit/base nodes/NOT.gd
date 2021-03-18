extends Button
var output
var base_leg = 1
func Calculate():
	for s in get_node("../Sockets").get_children():
		if s.value!=-1:
			output=1-s.value
		else:
			output=-1
	return output
	


func _on_Button_button_down():
	UIHandler.CreateUI(get_parent())
	Move.MoveStart(false)


func _on_Button_button_up():
	Move.hold=false
