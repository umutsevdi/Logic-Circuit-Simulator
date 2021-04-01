extends Button
var output
var base_leg = 2

func _ready():
	var _s1=self.connect("button_down",get_parent(),"_on_Button_button_down")
	var _s2=self.connect("button_up",get_parent(),"_on_Button_button_up")
	
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
	

