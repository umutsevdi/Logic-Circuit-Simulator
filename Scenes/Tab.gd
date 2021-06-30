extends Node2D
var path=null
var saved=true #Will be used later as an array to implement Undo Redo actions
var format="Scene"
var history=[]

func AppendHistory(action_dictionary):
	history.append(action_dictionary)
	if self.visible:
		get_tree().get_root().get_node("/root/Scene/CanvasLayer/History").UpdateHistory(self)
