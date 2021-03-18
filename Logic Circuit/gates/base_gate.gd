extends Node2D
const TYPE = "Gate"
var socket=preload("res://base nodes/input.tscn")
var value=-1
var legs=0
func _ready():
	ResizeLegs(get_node("Gate").base_leg)
func _physics_process(_delta):
	value = $Gate.Calculate()
	$Outputs/Output.SetValue(value)

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
		$Sockets.rect_size.y=36*$Sockets.get_child_count()
		#$Outputs.rect_size.y=25*$Outputs.get_child_count()
		$Gate.rect_size.y=36*$Sockets.get_child_count()
		$Gate/Label.rect_size.y=36*$Sockets.get_child_count()
func CreateNode():
	UIHandler.CreateUI(self)
	Move.MoveStart(true)
	
