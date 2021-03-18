extends Control
const TYPE = "Input"
var connected=false
var source=null
var value = -1
var mouse=false
var fiber=preload("res://base nodes/fiber.tscn")
func _ready():	set_process(false)

func _physics_process(delta):
	
	if mouse and $Blocks.rect_scale.x<1.5:
		$Blocks.rect_scale+=Vector2(5*delta,5*delta)
	elif mouse and $Blocks.rect_scale>=Vector2(1.5,1.5):
		$Blocks.rect_scale=Vector2(1.5,1.5)
	elif !mouse and $Blocks.rect_scale.x>1:
		$Blocks.rect_scale-=Vector2(5*delta,5*delta)
	else:
		$Blocks.rect_scale=Vector2(1,1)
func _process(delta):

	if value==1 and $Blocks/off.modulate.a>0:	$Blocks/off.modulate.a-=5*delta
	elif value==0 and $Blocks/off.modulate.a<1:	$Blocks/off.modulate.a+=5*delta
	elif value==1 and $Blocks/off.modulate.a<=0:
		$Blocks/off.modulate.a=0
		set_process(false)
	else:
		$Blocks/off.modulate.a=1
		set_process(false)
		
# STATE 2 DECLARES THE GATE IS ABOUT TO BE DELETED SO CANCELS THE CONNECTION OTHER VALUES ARE JUST RAW VALUES
func SetValue(state):
	if state!=2: 
		if state!=value:
			#print("Setting\t",self,"\tto\t",state)
			set_process(true)
		value=state
		if connected:
			get_node(source.name).SetColor(state)
	else:
		 DisconnectOutput()
	
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
	elif Input.is_action_just_pressed("right_click") and connected:
		self.DisconnectOutput()


func ConnectOutput(node,placeholderline):
	connected=true
	source=node
	var line = fiber.instance()
	line.source=node
	line.target=self
	line.name=source.name
	#line.set_default_color(Color("#000028"))
	line.position=Vector2(12.5,12.5)
	for p in placeholderline.points:
		line.add_point(p)
	line.points[0]=Vector2(0,0)
	line.points[line.points.size()-1]=node.rect_global_position
	self.add_child(line)

	source.connect("value_changed",self,"SetValue")
	source.connection+=1
	print("\t",self,"\tConnected to\t",node)
	
func DisconnectOutput():
	self.SetValue(-1)
	source.connection-=1
	print("\t",self,"\tdisconnected from\t",source)
	connected=false

	get_node(source.name).queue_free()
	source.disconnect("value_changed",self,"SetValue")

	source=null	
