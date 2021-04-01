extends Panel
onready var icons={
	#Node Icons
	"Create":"res://Assets/Icons/Add.svg",
	"Move":"res://Assets/Icons/ToolMove.svg",
	"Delete":"res://Assets/Icons/Remove.svg",
	"Rotate":"res://Assets/Icons/ToolRotate.svg",
	"ResizeLegs":"res://Assets/Icons/TextureArray.svg",
	#File Icons
	"CreateScene":"res://Assets/Icons/CreateNewSceneFrom.svg",#New Scene
	"CreatePrefab":"res://Assets/Icons/New.svg", #New Prefab
	"Open":"res://Assets/Icons/Load.svg", #Open Prefab
	"Save":"res://Assets/Icons/Save.svg", #Save
	"Rename":"res://Assets/Icons/Edit.svg", #File renamed
}

func UpdateHistory(Tab):
	var event=Tab.history[Tab.history.size()-1]
	var string
	if event.has("Node"):
		string=(event.Node.name).left(4)+event.Node.name.right(event.Node.name.length()-4)
	elif event.has("Tab"):
		string=event.Tab.get_parent().name
	else:
		string=Tab.name
	if event.Action=="Create":
		string+="    ("+str(int(event.Node.position.x))+","+str(int(event.Node.position.y))+")"
	elif event.Action=="Move":
		string+="    ("+str(int(event.From.x))+","+str(int(event.From.y))+")"+"    to    ("+str(int(event.To.x))+","+str(int(event.To.y))+")"
	elif event.Action=="ResizeLegs" or event.Action=="Rotate":
		string+="    "+str(event.From)+"    to    "+str(event.To)
	elif event.Action=="Save":
		string+="    Saved"
	$ScrollContainer/Itemlist.add_item(string,load(icons[event.Action]))
	print("=",event.Action,"\t",string)
func SwitchTab():
	$ScrollContainer/Itemlist.clear()
	var Tab=Database.GetCurrentTab()
	var event
	for i in range (Tab.history.size()):
		event=Tab.history[i]
		var string
		if event.has("Node"):
			string=(event.Node.name).left(4)+event.Node.name.right(event.Node.name.length()-4)
		elif event.has("Tab"):
			string=event.Tab.get_parent().name
		else:
			string=Tab.name
		if event.Action=="Create":
			string+="    ("+str(int(event.Node.position.x))+","+str(int(event.Node.position.y))+")"
		elif event.Action=="Move":
			string+="    ("+str(int(event.From.x))+","+str(int(event.From.y))+")"+"    to    ("+str(int(event.To.x))+","+str(int(event.To.y))+")"
		elif event.Action=="ResizeLegs":
			string+="    "+str(event.From)+"    to    "+str(event.To)
		$ScrollContainer/Itemlist.add_item(string,load(icons[event.Action]))
