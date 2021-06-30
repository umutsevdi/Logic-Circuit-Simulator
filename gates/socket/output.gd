extends Control
#output creates an information based on the gate
const TYPE = "Output"
var label:=false
var label_text := ""

var connection = {}
var value := false

var mouse_on :=false

func _ready():
	if label:
		get_node("Label").visible=true
		get_node("Label").text=label_text

func _physics_process(delta):
	if mouse_on and self.rect_scale.x<1.5:
		self.rect_scale.x+=3*delta
		self.rect_scale.y+=3*delta
	elif mouse_on==false and self.rect_scale.x>1:
		self.rect_scale.x-=3*delta
		self.rect_scale.y-=3*delta
	if value and get_node("off").modulate.a>0:
		get_node("off").modulate.a-=delta*5
	elif value==false and get_node("off").modulate.a<1:
		get_node("off").modulate.a+=delta*5
		
#Pushes the received value to all connected inputs
func push_value(result : bool):
	self.value=result
	#If there is a connection, triggers the signal
	if connection.size()>0:
		emit_signal("value_changed",value)
	
func _on_Button_pressed():
	pass # Replace with function body.


func _on_Button_mouse_entered():
	mouse_on=true


func _on_Button_mouse_exited():
	mouse_on=false
