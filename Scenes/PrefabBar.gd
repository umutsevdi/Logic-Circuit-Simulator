extends Panel
var folder=preload("res://UI/FolderButton.tscn")
var file=preload("res://UI/FileButton.tscn")
func _ready():
	_on_RefreshButton_pressed()
	$HBoxContainer/Button.pressed=true
	
func _on_Path_text_entered(new_text):
	if new_text=="res://":
		get_node("HBoxContainer/Path").text="user://"
	elif new_text=="C:":
		get_node("HBoxContainer/Path").text="C:/"
	_on_RefreshButton_pressed()
func _on_RefreshButton_pressed():
	var path=get_node("HBoxContainer/Path").text
	dir_contents(path)

func dir_contents(path):
	for i in get_node("ScrollContainer/VBoxContainer").get_children():
		i.queue_free()
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name!="." and file_name!="..":
				var unit=folder.instance()
				unit.name=file_name
				unit.get_node("Label").text=file_name
				get_node("ScrollContainer/VBoxContainer").add_child(unit)
			elif file_name.get_extension()=="json":
				var unit=file.instance()
				unit.name=file_name
				unit.get_node("Label").text=file_name
				var item=Database.OpenDirectory(path+"/"+file_name)
				if item.error!=0:
					print("Error\tat opening file:\t",item.error,path+"/"+file_name)
				else:
					item=item.result
					if item.has("Format"):
						if item["Format"]=="Prefab" or item["Format"]=="Scene":
							unit.path=path+"/"+file_name
							unit.Item=item
						else:
							unit.get_node("Button").disabled=true
							unit.get_node("Label").modulate=Color("#5b5d54")
						get_node("ScrollContainer/VBoxContainer").add_child(unit)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _on_UpButton_pressed():
	get_node("HBoxContainer/Path").text=get_node("HBoxContainer/Path").text.replace("/"+get_node("HBoxContainer/Path").text.get_file(),"")
	_on_RefreshButton_pressed()

func _on_Button_toggled(button_pressed):
	if button_pressed:
		$HBoxContainer/Path.text="user://"
	else:
		$HBoxContainer/Path.text="C:/"
	_on_RefreshButton_pressed()
