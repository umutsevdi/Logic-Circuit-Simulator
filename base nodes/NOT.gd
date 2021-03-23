extends Button
var output
var base_leg = 1
func _ready():
	self.connect("button_down",get_parent(),"_on_Button_button_down")
	self.connect("button_up",get_parent(),"_on_Button_button_up")
func Calculate():
	for s in get_node("../Sockets").get_children():
		if s.value!=-1:
			output=1-s.value
		else:
			output=-1
	return output
	
