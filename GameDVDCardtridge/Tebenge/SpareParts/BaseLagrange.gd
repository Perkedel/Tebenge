extends VBoxContainer

class_name BaseLagrange
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func hideAllODs():
	for ODs in get_children():
		ODs.hide()

# Called when the node enters the scene tree for the first time.
func _ready():
	for Odees in get_children():
		if Odees.has_signal("pressedOption"):
			Odees.connect("pressedOption",self,"_receiveOdeePressOption",[name])
		pass
	_readyCustom()
	pass # Replace with function body.

func _readyCustom()->void:
	# There is no super. so override this instead.
	pass

func gotNewHiScore(isIt:bool = false, score:int = 0):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal LagrangeWantsTo(nameOf,fromOD, fromLagrange)

func _receiveOdeePressOption(named:String, fromOD:String, fromLagrangeOf:String):
	print("Pressed %s from Lagrange %s from OD %s" % [String(named), String(fromLagrangeOf), String(fromOD)])
	emit_signal("LagrangeWantsTo",named,fromOD,fromLagrangeOf)
	pass
