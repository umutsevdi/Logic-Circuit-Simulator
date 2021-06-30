extends Button
const input_count := 2 
const  output_count = 1
func _ready():
	var _s1 = self.connect("button_down",get_parent(),"on_button_down")
	var _s2 = self.connect("button_up",get_parent(),"on_button_up")		
func calculate(array : Array):
	if array.size()!=2:
		return null
	else:
		return [true] if (array[0]!=array[1]) else [false]
