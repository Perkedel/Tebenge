extends HBoxContainer

class_name BaseOD
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(bool) var queryFocusButtonFromLast:bool = false
export(int) var startQueryFromSelectionNum:int = 0

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

func _obtainButtonFocus(forChildNumber:int = 0, inReverse:bool = true):
	# WHYNT WORKING?!?!??!
	if get_child_count() > 0:
		if inReverse:
			if forChildNumber >= 0:
				if get_child(forChildNumber) is Button:
					if get_child(forChildNumber).visible && get_child(forChildNumber).focus_mode != FOCUS_NONE:
						get_child(forChildNumber).grab_focus()
					else:
						_obtainButtonFocus(forChildNumber+1 if !inReverse else forChildNumber-1,inReverse)
				else:
					_obtainButtonFocus(forChildNumber+1 if !inReverse else forChildNumber-1,inReverse)
				pass
			pass
		else:
			if forChildNumber < get_child_count():
				if get_child(forChildNumber) is Button:
					if get_child(forChildNumber).visible && get_child(forChildNumber).focus_mode != FOCUS_NONE:
						get_child(forChildNumber).grab_focus()
					else:
						_obtainButtonFocus(forChildNumber+1 if !inReverse else forChildNumber-1,inReverse)
				else:
					_obtainButtonFocus(forChildNumber+1 if !inReverse else forChildNumber-1, inReverse)
	pass

func _simplerObtainButtonFocus(forChildNumber:int = 0):
	if get_child_count() > 0:
		if forChildNumber < get_child_count():
			if get_child(forChildNumber) is Button:
				if get_child(forChildNumber).visible && get_child(forChildNumber).focus_mode != FOCUS_NONE:
					get_child(forChildNumber).grab_focus()
				else:
					_simplerObtainButtonFocus(forChildNumber+1)
			else:
				_simplerObtainButtonFocus(forChildNumber+1)
		pass
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if visible:
#			_obtainButtonFocus(startQueryFromSelectionNum if !queryFocusButtonFromLast else (get_child_count()-1)-startQueryFromSelectionNum)
			_simplerObtainButtonFocus(startQueryFromSelectionNum)
		pass
