extends Node2D
const TYPE = "Gate"
var socket=preload("res://base nodes/input.tscn")
var value=-1
var legs=0
var from_file=false
func _ready():
	if from_file==false:
		ResizeLegs(get_node("Gate").base_leg)
func _physics_process(_delta):
	value = $Gate.Calculate()
	$Outputs/Output.SetValue(value)
	
func CreateLegsFromInstance(Info):
	for i in Info.Inputs.keys():
		legs+=1
		var s = socket.instance()
		s.name=i
		$Sockets.add_child(s)
		
func ResizeLegs(leg_count):
	legs=leg_count
	if legs>$Sockets.get_child_count():
		for _i in range(legs-$Sockets.get_child_count()):
			var s = socket.instance()
			s.name="Input"+str(s.get_instance_id())
			$Sockets.add_child(s)
	elif legs<$Sockets.get_child_count():
		for i in range($Sockets.get_child_count()-legs):
			if $Sockets.get_child(i).connected:
				$Sockets.get_child(i).DisconnectOutput()
			if $Outputs/Output.connection:
				$Outputs/Output.emit_signal("value_changed",2)
			$Sockets.get_child(i).queue_free()
	if $Gate/Label.text!="NOT":
		$Gate.rect_size.y=36*legs
		$Gate.rect_position.y=-18*legs
		$Gate.rect_pivot_offset.y=18*legs
		$Gate/Label.rect_size.y=36*legs
		$Gate/Label.rect_pivot_offset.y=18*legs
	UIHandler.CreateUI(self)
	
func CreateNode():
	UIHandler.CreateUI(self)
	Move.MoveStart(true,self)

func _on_Button_button_down():
	if Move.create:
		Move.hold=false
	else:
		Move.MoveStart(false,self)

func _on_Button_button_up():
	Move.hold=false

