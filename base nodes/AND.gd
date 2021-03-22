extends Button
var output
var base_leg = 2
func Calculate():
	if get_node("../Sockets").get_child_count()>0:
		output=1
		for s in get_node("../Sockets").get_children():
			if s.value==0:
				output=0
			elif s.value==-1:
				return -1
	else:
		output=-1
	return output
	
func _on_Button_button_down():
	UIHandler.CreateUI(get_parent())
	Move.MoveStart(false)

func _on_Button_button_up():
	Move.hold=false
	
	
