extends Node

var parente:Node
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	parente = get_parent()
	if parente != null:
		if Engine.has_singleton("Singletoner"):
			pass
		else:
			parente.get_node("ChangeDVDButton").hide()
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
