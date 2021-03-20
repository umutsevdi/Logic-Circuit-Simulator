extends Node2D
const TYPE = "Prefab"
var socket=preload("res://base nodes/input.tscn")
var output=preload("res://base nodes/output.tscn")
var value=-1
var legs=0
var Info=null
var path=null
var Item=null
var time=0
func _physics_process(delta):
	$Gate.Calculate()

func CreateNode():
	Database.CreatePrefab(path,Item["Items"],Item["PrefabItems"],get_node("Gate/Tab"))
	UIHandler.CreateUI(self)
	Move.MoveStart(true)
	ResizeLegs()
	
func ResizeLegs():
	if Info!=null:
		for i in Info.Inputs.keys():
			var s = socket.instance() 
			s.name=i
			$Sockets.add_child(s)
		for i in Info.Outputs.keys():
			var s=output.instance()
			s.name=i
			$Outputs.add_child(s)
	else:
		for i in get_node("Gate/Tab/PrefabItems/Outputs").get_children():
			var s = socket.instance()
			s.name=i.name
			$Sockets.add_child(s)
		for i in get_node("Gate/Tab/PrefabItems/Inputs").get_children():
			var s = output.instance()
			s.name="O"+str(i.get_instance_id())
			$Outputs.add_child(s)
	$Sockets.rect_size.y=36*$Sockets.get_child_count()
	$Outputs.rect_size.y=25*$Outputs.get_child_count()
	$Gate.rect_size.y=36*$Sockets.get_child_count()
	$Gate/Label.rect_size.y=36*$Sockets.get_child_count()
func DeleteNode():
	for i in range($Sockets.get_child_count()):
		if $Sockets.get_child(i).connected:
			$Sockets.get_child(i).DisconnectOutput()
	for i in range($Outputs.get_child_count()):
		if $Outputs.get_child(i).connection:
			$Outputs.get_child(i).emit_signal("value_changed",2)
		$Sockets.get_child(i).queue_free()
	if $Gate/Label.text!="NOT":
		$Sockets.rect_size.y=36*$Sockets.get_child_count()
		$Gate.rect_size.y=36*$Sockets.get_child_count()
		$Gate/Label.rect_size.y=36*$Sockets.get_child_count()
