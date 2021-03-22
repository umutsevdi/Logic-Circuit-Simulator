extends TabContainer
onready var dialog=get_parent().get_node("FileDialog")
var visible_scene
func _ready():
	get_node("Simulator/HBoxContainer/Circuit Toolbar").pressed=true
	get_node("Simulator/HBoxContainer/Prefab Toolbar").pressed=true

func _input(event):
	if event.is_action_pressed("Save"):
		_on_Save_pressed()

func _on_Save_pressed():
	for i in get_tree().get_root().get_node("/root/Scene/Tabs").get_children():
		if i.visible:
			visible_scene=i
			break
	print("Saving ", visible_scene.name)
	dialog.current_file=visible_scene.name
	if visible_scene.path!=null:
		Database.SaveScene(visible_scene,visible_scene.path)
	else:
		print("Filepath is not found: Switching to Save As ")
		_on_Save_As_pressed()
	
func _on_New_Scene_pressed():
	get_parent().get_node("CreateScene").EmptyBox("Scene")
	get_parent().get_node("CreateScene").popup()

func _on_New_Prefab_pressed():
	get_parent().get_node("CreateScene").EmptyBox("Prefab")
	get_parent().get_node("CreateScene").popup()

func _on_Open_pressed():
	dialog.current_file=""
	dialog.mode=0
	dialog.popup()

func _on_Save_As_pressed():
	dialog.current_file=""
	dialog.mode=4
	dialog.popup()

func _on_Close_pressed():
	pass

func _on_Rename_pressed():
	dialog.get_parent().get_node("RenameScene").popup()

func _on_RenameScene_confirmed():
		if get_parent().get_node("RenameScene/Container/LineEdit").text!="":
			var is_unique=true
			for i in get_parent().get_node("TabContainer").get_children():
				if i.name==get_parent().get_node("RenameScene/Container/LineEdit").text:
					is_unique=false
					break
					
			if is_unique:
				for i in get_tree().get_root().get_node("/root/Scene/Tabs").get_children():
					if i.visible:
						visible_scene=i
						break
						
				get_parent().get_node("TabContainer/"+str(visible_scene.name)).name=get_parent().get_node("RenameScene/Container/LineEdit").text
				visible_scene.name=get_parent().get_node("RenameScene/Container/LineEdit").text

func _on_Delete_pressed():
	get_node("../DeleteScene").popup()

func _on_DeleteScene_confirmed():
	for i in get_tree().get_root().get_node("/root/Scene/Tabs").get_children():
		if i.visible:
			visible_scene=i
			break
	get_node("../TabContainer").current_tab=0
	if visible_scene.path!=null:
		var dir = Directory.new()
		dir.remove(visible_scene.path)
	get_node("../TabContainer/"+visible_scene.name).queue_free()
	
	visible_scene.queue_free()

func _on_Circuit_Toolbar_toggled(button_pressed):
	if button_pressed:
		get_node("../CreateBar").visible=true
	else:
		get_node("../CreateBar").visible=false


func _on_Prefab_Toolbar_toggled(button_pressed):
	if button_pressed:
		get_node("../PrefabBar").visible=true
	else:
		get_node("../PrefabBar").visible=false
