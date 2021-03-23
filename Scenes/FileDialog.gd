extends FileDialog

func _on_FileDialog_file_selected(path):
	var visible_scene
	if self.mode==0:
			print("Opening ",path)
			Database.opening_error=false
			Database.OpenFile(path)
	elif self.mode==4:
			visible_scene=Database.GetCurrentTab()
			visible_scene.name=current_file.get_file().left(current_file.get_file().length()-5)
			visible_scene.path=path
			print(get_node("/root/Scene/CanvasLayer/TabContainer").current_tab)
			print(get_node("/root/Scene/CanvasLayer/TabContainer").get_tab_control(get_node("/root/Scene/CanvasLayer/TabContainer").current_tab).name)
			get_node("/root/Scene/CanvasLayer/TabContainer").get_tab_control(get_node("/root/Scene/CanvasLayer/TabContainer").current_tab).name=current_file.get_file().left(current_file.get_file().length()-5)
			print(get_node("/root/Scene/CanvasLayer/TabContainer").get_tab_control(get_node("/root/Scene/CanvasLayer/TabContainer").current_tab).name)
			print("Saving",visible_scene.name,"to ",path)
			Database.SaveScene(visible_scene,path)
