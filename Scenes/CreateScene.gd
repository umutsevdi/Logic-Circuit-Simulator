extends AcceptDialog
var prefab_item=preload("res://Scenes/PrefabItems.tscn")
var input=preload("res://base nodes/input.tscn")
var output=preload("res://base nodes/output.tscn")
onready var tab_container=get_parent().get_node("TabContainer")

func EmptyBox(format):
	if format=="Scene":
		get_parent().get_node("CreateScene").window_title="Create Scene"
		get_parent().get_node("CreateScene").dialog_text="Create a scene and use as a workplace"
		
		$VBoxContainer/InputCountContainer.visible=false
		$VBoxContainer/OutputCountContainer.visible=false
	elif format=="Prefab":
		get_parent().get_node("CreateScene").window_title="Create Prefab"
		get_parent().get_node("CreateScene").dialog_text="Create a prefab to use on your scenes"
		$VBoxContainer/InputCountContainer.visible=true
		$VBoxContainer/OutputCountContainer.visible=true
	$VBoxContainer/SceneTypeContainer/OptionButton.text=format
	$VBoxContainer/NameContainer/LineEdit.text=""
	$VBoxContainer/InputCountContainer/SpinBox.value=1
	$VBoxContainer/OutputCountContainer/SpinBox.value=1
		
func _on_CreateScene_confirmed():
	if $VBoxContainer/NameContainer/LineEdit.text=="":
		$VBoxContainer/NameContainer/LineEdit.text="New Tab"
	var new_scene=tab_container.CreateCustomTab($VBoxContainer/NameContainer/LineEdit.text)
	if new_scene!=null:
		new_scene.format=$VBoxContainer/SceneTypeContainer/OptionButton.text
		if new_scene.format=="Prefab":
			new_scene.add_child(prefab_item.instance())
			for _i in range (get_node("VBoxContainer/OutputCountContainer/SpinBox").value):
				var inp=input.instance()
				inp.name="I"+str(inp.get_instance_id())
				new_scene.get_node("PrefabItems/Inputs").add_child(inp)
			for _i in range (get_node("VBoxContainer/InputCountContainer/SpinBox").value):
				var out=output.instance()
				out.name="O"+str(out.get_instance_id())
				new_scene.get_node("PrefabItems/Outputs").add_child(out)

func _on_OptionButton_item_selected(_index):
	if $VBoxContainer/SceneTypeContainer/OptionButton.text=="Scene":
		get_parent().get_node("CreateScene").window_title="Create Scene"
		get_parent().get_node("CreateScene").dialog_text="Create a scene and use as a workplace"
		$VBoxContainer/InputCountContainer.visible=false
		$VBoxContainer/OutputCountContainer.visible=false
	else:
		get_parent().get_node("CreateScene").window_title="Create Prefab"
		get_parent().get_node("CreateScene").dialog_text="Create a prefab to use on your scenes"
		$VBoxContainer/InputCountContainer.visible=true
		$VBoxContainer/OutputCountContainer.visible=true
