extends Control
const TYPE = "Output"
var value = -1
var mouse=false

signal value_changed
var connection=0
var coloring=false

func _process(delta):
	if mouse and $Blocks.rect_scale.x<1.5:
		$Blocks.rect_scale+=Vector2(5*delta,5*delta)
	elif mouse and $Blocks.rect_scale>=Vector2(1.5,1.5):
		$Blocks.rect_scale=Vector2(1.5,1.5)
	elif !mouse and $Blocks.rect_scale.x>1:
		$Blocks.rect_scale-=Vector2(5*delta,5*delta)
	else:
		$Blocks.rect_scale=Vector2(1,1)
		
	if coloring:
		if value==1 and $Blocks/off.modulate.a>0:	$Blocks/off.modulate.a-=5*delta
		elif value==0 and $Blocks/off.modulate.a<1:	$Blocks/off.modulate.a+=5*delta
		elif value==1 and $Blocks/off.modulate.a<=0:
			$Blocks/off.modulate.a=0
			coloring=false
		else:
			$Blocks/off.modulate.a=1
			coloring=false

func SetValue(state):
	if state!=value:
		coloring=true
	if state>0:
		value=state
	else:
		value=0
	emit_signal("value_changed",value)

func _on_Button_mouse_entered():
	mouse=true
func _on_Button_mouse_exited():
	mouse=false

func _on_Button_pressed():
	if Input.is_action_just_pressed("left_click"):
		if UIHandler.connecting:
			UIHandler.connect_nodes(self)
		else:
			UIHandler.start_connection(self)
