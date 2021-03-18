extends Node

onready var tabs_node = get_tree().get_root().get_node("/root/Scene/Tabs")
onready var tab_container = get_tree().get_root().get_node("/root/Scene/CanvasLayer/TabContainer")
var input = preload("res://base nodes/input.tscn")
var output = preload("res://base nodes/output.tscn")
var prefab_item=preload("res://Scenes/PrefabItems.tscn")
var gates={
	"Variable":preload("res://base nodes/variable.tscn"),
	"Clock":preload("res://base nodes/clock.tscn"),
	"AND":preload("res://gates/AND_gate.tscn"),
	"NAND":preload("res://gates/NAND_gate.tscn"),
	"NOT": preload("res://gates/NOT_gate.tscn"),
	"OR": preload("res://gates/OR_gate.tscn"),
	"NOR": preload("res://gates/NOR_gate.tscn"),
	"XOR": preload("res://gates/XOR_gate.tscn"),
	"XNOR": preload("res://gates/XNOR_gate.tscn")
}
var Prefabs={}
var Scenes={}
func SaveScene(tab,filepath):
	print("Saving Tab:\t",tab)
	var TabData={}
	for i in tab.get_children():
		if i.get_node("Gate/Label").text=="Variable":
			TabData[i.name]={"Type":i.get_node("Gate/Label").text,"Position":{"x":i.position.x,"y":i.position.y},"Value":i.value,"Outputs":{}}
			for out in i.get_node("Outputs").get_children():
				TabData[i.name].Outputs[out.name]={"Connection":out.connection,"Value":out.value}
		elif i.get_node("Gate/Label").text=="Clock":
			TabData[i.name]={"Type":i.get_node("Gate/Label").text,"Position":{"x":i.position.x,"y":i.position.y},"Cycle":1/i.get_node("Timer").wait_time,"Outputs":{}}
			for out in i.get_node("Outputs").get_children():
				TabData[i.name].Outputs[out.name]={"Connection":out.connection,"Value":out.value}		
		elif i.get_node("Gate/Label").text in gates.keys():
			TabData[i.name]={"Type":i.get_node("Gate/Label").text,"Position":{"x":i.position.x,"y":i.position.y},"Inputs":{},"Outputs":{}}
			for inp in i.get_node("Sockets").get_children():
				if inp.connected:
					var line={}
					for l in range (inp.get_node(inp.source.name).points.size()):
						line[l]={"x":inp.get_node(inp.source.name).points[l].x,"y":inp.get_node(inp.source.name).points[l].y}
					TabData[i.name].Inputs[inp.name]={"Source":{"Parent":inp.source.get_parent().get_parent().name,"Socket":inp.source.name,"Line":line},"Value":inp.value}
				else:
					TabData[i.name].Inputs[inp.name]={"Source":{"Parent":"null","Socket":"null","Line":"null"},"Value":inp.value}
			for out in i.get_node("Outputs").get_children():
				TabData[i.name].Outputs[out.name]={"Connection":out.connection,"Value":out.value}
		elif i.name!="PrefabItems":
			TabData[i.name]={"Type":"Prefab","Position":{"x":i.position.x,"y":i.position.y},"Inputs":{},"Outputs":{},"Path":i.path}
			for inp in i.get_node("Sockets").get_children():
				if inp.connected:
					var line={}
					for l in range (inp.get_node(inp.source.name).points.size()):
						line[l]={"x":inp.get_node(inp.source.name).points[l].x,"y":inp.get_node(inp.source.name).points[l].y}
					TabData[i.name].Inputs[inp.name]={"Source":{"Parent":inp.source.get_parent().get_parent().name,"Socket":inp.source.name,"Line":line},"Value":inp.value}
				else:
					TabData[i.name].Inputs[inp.name]={"Source":{"Parent":"null","Socket":"null","Line":"null"},"Value":inp.value}
			for out in i.get_node("Outputs").get_children():
				TabData[i.name].Outputs[out.name]={"Connection":out.connection,"Value":out.value}
	var FileSetup
	if tab.format=="Scene":
		FileSetup={"Format":"Scene","Items":TabData}
	elif tab.format=="Prefab":
		FileSetup={"Format":"Prefab","Items":TabData,"PrefabItems":{"Inputs":{},"Outputs":{}}}
		for i in tab.get_node("PrefabItems/Outputs").get_children():
			FileSetup["PrefabItems"].Outputs[i.name]={"Connection":i.connection,"Value":i.value}
		for i in tab.get_node("PrefabItems/Inputs").get_children():
			if i.connected:
				var line={}
				for l in range (i.get_node(i.source.name).points.size()):
					line[l]={"x":i.get_node(i.source.name).points[l].x,"y":i.get_node(i.source.name).points[l].y}
				FileSetup["PrefabItems"].Inputs[i.name]={"Source":{"Parent":i.source.get_parent().get_parent().name,"Socket":i.source.name,"Line":line},"Value":i.value}
			else:
				FileSetup["PrefabItems"].Inputs[i.name]={"Source":{"Parent":"null","Socket":"null","Line":"null"},"Value":i.value}
	var save_file=File.new()
	if filepath=="":
		save_file.open("user://scenes/"+tab.name+".json",File.WRITE)
	else:
		save_file.open(filepath,File.WRITE)
	save_file.store_line(to_json(FileSetup))
	save_file.close()

func OpenFile(directory):
	var Item={}
	Item=OpenDirectory(directory)
	if Item.error!=0:
		print("Error\tat opening file:\t",Item.error)
	else:
		Item=Item.result
		if Item.has("Format"):
			if Item["Format"]=="Scene":
				CreateScene(directory,Item["Items"])
			else:
				var TabName=directory.get_file().left(directory.get_file().length()-5)
				var tab=tab_container.CreateCustomTab(TabName)
				CreatePrefab(directory,Item["Items"],Item["PrefabItems"],tab)
		else:
			return "Error"

	
func OpenDirectory(directory):
	var Item={}
	var file=File.new()
	file.open(directory,File.READ)
	Item=JSON.parse(file.get_as_text())
	file.close()
	return Item
	
func CreateScene(Filepath,TabData):
	var TabName=Filepath.get_file().left(Filepath.get_file().length()-5)
	var tab=tab_container.CreateCustomTab(TabName)
	tab.format="Scene"
	tab.path=Filepath
	if tab!=null:
		for i in TabData.keys():
			var unit=null
			if TabData[i].Type in gates.keys():
				unit=gates[TabData[i].Type].instance()
			unit.position.x=TabData[i].Position.x
			unit.position.y=TabData[i].Position.y
			tab.add_child(unit)
			unit.name=i
			if TabData[i].Type=="Clock":
				unit.get_node("SpinBox").value=TabData[i].Cycle
			elif TabData[i].Type=="Variable":
				if TabData[i].Value==1:	unit.get_node("CheckButton").pressed=true
			print("\tCreating\t",i,"\tat\t",TabData[i].Position.x,",",TabData[i].Position.y)
			if unit.has_node("Sockets"):
				for j in unit.get_node("Sockets").get_children():
					j.queue_free()
			if TabData[i].has("Inputs"):
				for j in TabData[i].Inputs.keys():
					var socket = input.instance()
					socket.name=j
					unit.get_node("Sockets").add_child(socket)
			if TabData[i].has("Outputs"):
				unit.get_node("Outputs/Output").SetValue(TabData[i].Outputs["Output"].Value)
				if TabData[i].Outputs.keys().size()>1:
					for j in TabData[i].Outputs.keys():
						var socket = output.instance()
						socket.name=j
						socket.SetValue(TabData[i].Outputs[j].Value)
						unit.get_node("Outputs").add_child(socket)
		for i in TabData.keys():
			if TabData[i].has("Inputs"):
				for j in TabData[i].Inputs.keys():
					if TabData[i].Inputs[j].Source["Parent"]!="null":
						print("\t=",TabName,"\t",i,"\t",j)
						var target=tabs_node.get_node(TabName+"/"+i+"/Sockets/"+j)
						var source=tabs_node.get_node(TabName+"/"+TabData[i].Inputs[j].Source.Parent+"/Outputs/"+TabData[i].Inputs[j].Source.Socket)
						print("\t=",str(TabName+"/"+TabData[i].Inputs[j].Source.Parent+"/Outputs/"+TabData[i].Inputs[j].Source.Socket))
						var line= Line2D.new()
						for l in TabData[i].Inputs[j].Source.Line:
							line.add_point(Vector2(TabData[i].Inputs[j].Source.Line[l].x,TabData[i].Inputs[j].Source.Line[l].y))
						#line.points=TabData[i].Inputs[j].Source.Line
						target.ConnectOutput(source,line)
						line.queue_free()
						source.SetValue(source.value)
#PREFAB OF PREFAB: NEEDS TO BE ADDED FROM THE FILE IT REQUESTS!
func CreatePrefab(Filepath,TabData,PrefabItems,tab):
	var TabName=tab.name

	tab.format="Prefab"
	tab.path=Filepath
	tab.add_child(prefab_item.instance())
	

	if tab!=null:
		for i in PrefabItems.Inputs.keys():
			var inp=input.instance()
			inp.name=i
			tab.get_node("PrefabItems/Inputs").add_child(inp)
		for i in PrefabItems.Outputs.keys():
			var out=output.instance()
			out.name=i
			tab.get_node("PrefabItems/Outputs").add_child(out)
		for i in TabData.keys():
			var unit=null
			if TabData[i].Type in gates.keys():
				unit=gates[TabData[i].Type].instance()
			unit.position.x=TabData[i].Position.x
			unit.position.y=TabData[i].Position.y
			tab.add_child(unit)
			unit.name=i
			if TabData[i].Type=="Clock":
				unit.get_node("SpinBox").value=TabData[i].Cycle
			elif TabData[i].Type=="Variable":
				if TabData[i].Value==1:	unit.get_node("CheckButton").pressed=true
			print("\tCreating\t",i,"\tat\t",TabData[i].Position.x,",",TabData[i].Position.y)
			if unit.has_node("Sockets"):
				for j in unit.get_node("Sockets").get_children():
					j.queue_free()
			if TabData[i].has("Inputs"):
				for j in TabData[i].Inputs.keys():
					var socket = input.instance()
					socket.name=j
					unit.get_node("Sockets").add_child(socket)
			if TabData[i].has("Outputs"):
				unit.get_node("Outputs/Output").SetValue(TabData[i].Outputs["Output"].Value)
				if TabData[i].Outputs.keys().size()>1:
					for j in TabData[i].Outputs.keys():
						var socket = output.instance()
						socket.name=j
						socket.SetValue(TabData[i].Outputs[j].Value)
						unit.get_node("Outputs").add_child(socket)
		for i in TabData.keys():
			if TabData[i].has("Inputs"):
				for j in TabData[i].Inputs.keys():
					if TabData[i].Inputs[j].Source["Parent"]!="null":
						print("\t=",TabName,"\t",i,"\t",j)
						var target=tab.get_node(i+"/Sockets/"+j)
						var source=tab.get_node(TabData[i].Inputs[j].Source.Parent+"/Outputs/"+TabData[i].Inputs[j].Source.Socket)
						print("\t=",str(TabName+"/"+TabData[i].Inputs[j].Source.Parent+"/Outputs/"+TabData[i].Inputs[j].Source.Socket))
						var line= Line2D.new()
						for l in TabData[i].Inputs[j].Source.Line:
							line.add_point(Vector2(TabData[i].Inputs[j].Source.Line[l].x,TabData[i].Inputs[j].Source.Line[l].y))
						#line.points=TabData[i].Inputs[j].Source.Line
						target.ConnectOutput(source,line)
						line.queue_free()
						source.SetValue(source.value)
		for i in PrefabItems.Inputs.keys():
			if PrefabItems.Inputs[i].Source["Parent"]!="null":
				print("\tPrefabItem=",i,"\tto",PrefabItems.Inputs[i].Source["Parent"])
				var target=tab.get_node("PrefabItems/Inputs/"+i)
				var source=tab.get_node(PrefabItems.Inputs[i].Source.Parent+"/Outputs/"+PrefabItems.Inputs[i].Source.Socket)
				var line= Line2D.new()
				for l in PrefabItems.Inputs[i].Source["Line"]:
					line.add_point(Vector2(PrefabItems.Inputs[i].Source.Line[l].x,PrefabItems.Inputs[i].Source.Line[l].y))
				target.ConnectOutput(source,line)
				line.queue_free()
				source.SetValue(source.value)
