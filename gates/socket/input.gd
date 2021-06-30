extends Control
#input receives information from the outer source
const TYPE = "Input"
var label:=false
var label_text := ""

var connected := false
var source : Node2D
var value := false
signal input_changed

var mouse_on := false

func _ready():
	if label:
		get_node("Label").visible=true
		get_node("Label").text=label_text
	var _s = self.connect("input_changed",get_node("../.."),"calculate")

func _physics_process(delta):
	if mouse_on and self.rect_scale.x<1.5:
		self.rect_scale.x+=3*delta
		self.rect_scale.y+=3*delta
	elif mouse_on==false and self.rect_scale.x>1:
		self.rect_scale.x-=3*delta
		self.rect_scale.y-=3*delta
	if value and get_node("off").modulate.a>0:
		get_node("off").modulate.a-=delta*5
	elif !value and get_node("off").modulate.a<1:
		get_node("off").modulate.a+=delta*5
		
		
#Upon receiving a value calls the calculate() from the gate so the new outputs are calculated
func pull_value(result : bool): 
	if connected and source!=null:
		self.value=result
		emit_signal("input_changed")
			
func _on_Button_pressed():
	pass # Replace with function body.


func _on_Button_mouse_entered():
	mouse_on=true


func _on_Button_mouse_exited():
	mouse_on=false
