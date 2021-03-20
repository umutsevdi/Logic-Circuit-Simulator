extends Button
var output
var base_leg = 2
func Calculate():
	for i in range(get_node("Tab/PrefabItems/Outputs").get_child_count()):
		get_node("Tab/PrefabItems/Outputs").get_child(i).SetValue(get_node("../Sockets").get_child(i).value)
	for i in range(get_node("Tab/PrefabItems/Inputs").get_child_count()):
		get_node("../Outputs").get_child(i).SetValue(get_node("Tab/PrefabItems/Inputs").get_child(i).value)
	
func _on_Button_button_down():
	UIHandler.CreateUI(get_parent())
	Move.MoveStart(false)

func _on_Button_button_up():
	Move.hold=false
