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
	if get_node("../TabContainer").get_tab_control(get_node("../TabContainer").current_tab).name!="+":
		visible_scene=Database.GetCurrentTab()
		print("Saving ", visible_scene.name)
		dialog.current_file=visible_scene.name
		if visible_scene.path!=null:
			visible_scene.history.clear()
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
	if get_node("../TabContainer").get_tab_control(get_node("../TabContainer").current_tab).name!="+":
		dialog.current_file=""
		dialog.mode=4
		dialog.popup()

func _on_Close_pressed():
	if get_node("../TabContainer").get_tab_control(get_node("../TabContainer").current_tab).name!="+":
		if Database.GetCurrentTab().history.size()>0:
			if Database.GetCurrentTab().history[Database.GetCurrentTab().history.size()-1].Action!="Save":
				get_node("../CloseTab").popup()
			else:
				UIHandler.CloseCurrentTab()
		else:
			UIHandler.CloseCurrentTab()

func _on_Rename_pressed():
	if get_node("../TabContainer").get_tab_control(get_node("../TabContainer").current_tab).name!="+":
		dialog.get_parent().get_node("RenameScene").popup()

func _on_RenameScene_confirmed():
	if get_parent().get_node("RenameScene/Container/LineEdit").text!="":
		var is_unique=true
		for i in get_parent().get_node("TabContainer").get_children():
			if i.name==get_parent().get_node("RenameScene/Container/LineEdit").text:
				is_unique=false
				break
				
		if is_unique:
			visible_scene=Database.GetCurrentTab()
					
			get_parent().get_node("TabContainer/"+str(visible_scene.name)).name=get_parent().get_node("RenameScene/Container/LineEdit").text
			visible_scene.name=get_parent().get_node("RenameScene/Container/LineEdit").text

func _on_Delete_pressed():
	if get_node("../TabContainer").get_tab_control(get_node("../TabContainer").current_tab).name!="+":
		get_node("../DeleteScene").popup()

func _on_DeleteScene_confirmed():
	visible_scene=Database.GetCurrentTab()
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


func _on_Open_Truth_Table_pressed():
	if get_node("../TabContainer").get_tab_control(get_node("../TabContainer").current_tab).name!="+":
		get_node("../Truth Table").popup()


func _on_Sync_Clocks_pressed():
	if get_node("../TabContainer").get_tab_control(get_node("../TabContainer").current_tab).name!="+":
		visible_scene=Database.GetCurrentTab()
		for i in visible_scene.get_children():
			if i.TYPE=="Clock":
				i.get_node("Timer").start()

func _on_About_pressed():
	get_node("../About").popup()


func _on_Copyright_pressed():
	get_node("../Copyright").popup()

func _on_SaveWithoutClose_pressed():
	UIHandler.CloseCurrentTab()
	get_node("../CloseTab").visible=false


func _on_SaveAndClose_pressed():
	visible_scene=Database.GetCurrentTab()
	if visible_scene.path!=null:
		Database.SaveScene(visible_scene,visible_scene.path)
		UIHandler.CloseCurrentTab()
	else:
		print("Filepath is not found: Switching to Save As ")
		_on_Save_As_pressed()
	get_node("../CloseTab").visible=false
