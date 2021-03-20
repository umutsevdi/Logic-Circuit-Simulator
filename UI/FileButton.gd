extends Control
onready var tabs_node = get_tree().get_root().get_node("/root/Scene/Tabs")
onready var Prefab=preload("res://gates/prefab_gate.tscn")
var path
var Item

func _on_Button_down():
	var node=Prefab.instance()
	node.name=self.name+" "+str(node.get_instance_id())
	var selected_tab=null
	for i in tabs_node.get_children():
		if i.visible:	
			selected_tab=i
			break
	selected_tab.add_child(node)
	node.path=path
	node.Item=Item
	node.CreateNode()


