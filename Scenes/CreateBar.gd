extends Panel
onready var tabs_node = get_tree().get_root().get_node("/root/Scene/Tabs")
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


