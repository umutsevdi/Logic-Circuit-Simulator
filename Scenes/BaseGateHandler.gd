extends Node
var base_gate=preload("res://gates/base_gate.tscn")
var gates={
	"Output":preload("res://base nodes/output_gate.tscn"),
	"Label":preload("res://base nodes/Label.tscn"),
	"Variable":preload("res://base nodes/variable.tscn"),
	"Clock":preload("res://base nodes/clock.tscn"),
	"AND":preload("res://base nodes/AND.tscn"),
	"NAND":preload("res://base nodes/NAND.tscn"),
	"NOT": preload("res://base nodes/NOT.tscn"),
	"OR": preload("res://base nodes/OR.tscn"),
	"NOR": preload("res://base nodes/NOR.tscn"),
	"XOR": preload("res://base nodes/XOR.tscn"),
	"XNOR": preload("res://base nodes/XNOR.tscn")
}

func SetupUnit(gatetype):
	var node
	if gatetype=="Variable" or gatetype=="Clock" or gatetype=="Label" or gatetype=="Output":
		node=gates[gatetype].instance()
	else:
		node=base_gate.instance()
		var gate=gates[gatetype].instance()
		gate.rect_position.y=-36
		gate.rect_position.x=-40
		node.add_child(gate)
		node.move_child(gate,0)
	return node
