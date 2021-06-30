extends Node

var base_gate=preload("res://gates/gate.tscn")
var gates={
	#"Output":preload("res://base nodes/output_gate.tscn"),
	#"Label":preload("res://base nodes/Label.tscn"),
#	"VAR":preload("res://gates/calculators/variable.tscn"),
#	#"Clock":preload("res://base nodes/clock.tscn"),
#	"AND":preload("res://gates/calculators/and.tscn"),
#	"NAND":preload("res://gates/calculators/nand.tscn"),
#	"NOT": preload("res://gates/calculators/not.tscn"),
#	"OR": preload("res://gates/calculators/or.tscn"),
#	"NOR": preload("res://gates/calculators/nor.tscn"),
#	"XOR": preload("res://gates/calculators/xor.tscn"),
#	"XNOR": preload("res://gates/calculators/xnor.tscn")
}

func SetupUnit(gate_type):
	print("Setup : ",gate_type)
	var node
	if gate_type=="VAR" or gate_type=="Clock" or gate_type=="Label" or gate_type=="Output":
		node=gates[gate_type].instance()
	else:
		node=base_gate.instance()
		var gate=gates[gate_type].instance()
		node.gate_type=gate.name
	
		node.name = gate.name + str(OS.get_unix_time()%100000)
		node.add_child(gate)
		node.move_child(gate,0)
		
	return node
