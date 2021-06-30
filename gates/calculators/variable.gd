extends Node2D
const gate_type = "VAR"
#gate updates the output
func calculate():
	var result := []
	for iter in get_node("input").get_children():
		result.append(iter.value)
	result = get_node(gate_type).calculate(result)
	for i in range (result.size()):
		get_node("output").get_child(i).push_value(result[i])


func _on_CheckButton_toggled(button_pressed):
		get_node("output").get_child(0).push_value(button_pressed)
		

func _on_button_down():
	if Dragdrop.create:
		Dragdrop.is_holding=false
	else:
		Dragdrop.start_drag(false,self)
func _on_button_up():
	Dragdrop.is_holding=false
