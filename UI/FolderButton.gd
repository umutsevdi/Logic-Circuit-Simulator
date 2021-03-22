extends Control
var once=false
var iconpack=["res://Assets/Icons/PackedScene.svg","res://Assets/Icons/Object.svg","res://Assets/Icons/File.svg"]
func _on_Button_pressed():
	if once==false:
		$Timer.start()
		once=true
	else:
		get_node("../../../HBoxContainer/Path").text+="/"+get_node("Label").text
		get_node("../../..")._on_RefreshButton_pressed()

func _on_Timer_timeout():
	once=false
