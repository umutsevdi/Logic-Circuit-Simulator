extends Button
var output
var base_leg = 2
func _ready():
	var _s1=self.connect("button_down",get_parent(),"_on_Button_button_down")
	var _s2=self.connect("button_up",get_parent(),"_on_Button_button_up")
func Calculate():
	if get_node("../Sockets").get_child_count()>0 and get_node("../Sockets").get_child(1).value!=-1 and get_node("../Sockets").get_child(0).value!=-1:
		output=0
		if get_node("../Sockets").get_child(1).value!=get_node("../Sockets").get_child(0).value:
			return -1
		elif get_node("../Sockets").get_child(1).value==get_node("../Sockets").get_child(0).value:
			return 1
	else:
		output=-1
	return output
