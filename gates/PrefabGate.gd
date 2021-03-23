extends Button
var output
var base_leg = 2

func Calculate():
	if get_node("Tab").get_child_count()>0:
		for i in range(get_node("Tab/PrefabItems/Outputs").get_child_count()):
			get_node("Tab/PrefabItems/Outputs").get_child(i).SetValue(get_node("../Sockets").get_child(i).value)
		for i in range(get_node("Tab/PrefabItems/Inputs").get_child_count()):
			get_node("../Outputs").get_child(i).SetValue(get_node("Tab/PrefabItems/Inputs").get_child(i).value)
		
func _on_Button_button_down():
	if Move.create:
		Move.hold=false
	else:
		Move.MoveStart(false,self)

func _on_Button_button_up():
	Move.hold=false
