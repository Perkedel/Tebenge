extends VBoxContainer

class_name BaseLagrange
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for Odees in get_children():
		if Odees.has_signal("pressedOption"):
			Odees.connect("pressedOption",self,"_receiveOdeePressOption",[Odees.get_name()])
		pass
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _receiveOdeePressOption(named:String, fromLagrangeOf:String):
	print("Pressed %s from Node %s" % [named, fromLagrangeOf])
	pass
