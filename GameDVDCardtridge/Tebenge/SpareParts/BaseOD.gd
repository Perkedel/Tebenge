extends HBoxContainer

class_name BaseOD
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func mainMenuPls():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	for thingThere in get_children():
		if thingThere.has_signal("pressedName"):
			thingThere.connect("pressedName", self, "sendPressedOption", [name])
			pass
		pass
	pass # Replace with function body.

func gotNewHiScore(isIt:bool = false, score:int = 0):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal pressedOption(nameOf,oDName)

func sendPressedOption(named:String, oDName:String):
	print("Pressed %s" % [named])
	emit_signal("pressedOption",named,oDName)
	pass

func _obtainButtonFocus(forChildNumber:int = 0):
	if get_child(forChildNumber) is Button:
			if get_child(forChildNumber).visible:
				get_child(forChildNumber).grab_focus()
			else:
				_obtainButtonFocus(forChildNumber+1)
	else:
		_obtainButtonFocus(forChildNumber+1)
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		_obtainButtonFocus(0)
		pass
