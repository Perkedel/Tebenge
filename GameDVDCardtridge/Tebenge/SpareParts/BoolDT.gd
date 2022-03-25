tool
extends ComplexDT

export(String) var title = "Title" setget set_title
export(String) var value = "value" setget set_value
export(bool) var state = true setget set_state
onready var theLabel = $BoolLabel
onready var theCheck = $CheckButton

func _ready() -> void:
	theLabel.set_deferred("text",title)
	theCheck.set_deferred("text",value)
	pass

func set_title(into:String):
	title = into
#	if $BoolLabel != null && $BoolLabel.is_inside_tree():
#		$BoolLabel.text = title
	if theLabel != null:
#		theLabel.text = title
		theLabel.set_deferred("text",title)

func set_value(into:String):
	value = into
#	if $CheckButton != null && $CheckButton.is_inside_tree():
#		$CheckButton.text = value
	if theCheck != null:
#		theCheck.text = value
		theCheck.set_deferred("text",value)

signal changeState(into)
func set_state(into:bool = true):
	state = into
	if $CheckButton != null && $CheckButton.is_inside_tree():
		$CheckButton.pressed = state
	if theCheck != null:
		theCheck.set_deferred("pressed",state)
	emit_signal("changeState",into)
	print("Change State into %s" % String(into))

func grab_focus():
	if $CheckButton != null && $CheckButton.is_inside_tree():
		$CheckButton.grab_focus()
	if theCheck != null:
#		theCheck.grab_focus()
		theCheck.call_deferred("grab_focus")
	pass

func _on_CheckButton_toggled(button_pressed: bool) -> void:
	set_state(button_pressed)
	pass # Replace with function body.
