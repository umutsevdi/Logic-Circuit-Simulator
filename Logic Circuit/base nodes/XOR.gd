extends Button
var output
var base_leg = 2
func Calculate():
	if get_node("../Sockets").get_child_count()>0 and get_node("../Sockets").get_child(1).value!=-1 and get_node("../Sockets").get_child(0).value!=-1:
		output=0
		if get_node("../Sockets").get_child(1).value!=get_node("../Sockets").get_child(0).value:
			return 1
		elif get_node("../Sockets").get_child(1).value==get_node("../Sockets").get_child(0).value:
			return -1
	else:
		output=-1
	return output
	


func _on_Button_button_down():
	UIHandler.CreateUI(get_parent())
	Move.MoveStart(false)


func _on_Button_button_up():
	Move.hold=false
