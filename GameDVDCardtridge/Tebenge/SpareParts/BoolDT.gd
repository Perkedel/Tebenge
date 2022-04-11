tool
extends ComplexDT

export(String) var title:String = "Title" setget set_title
export(String) var value:String = "value" setget set_value
export(Texture) var icon:Texture = load("res://GameDVDCardtridge/Tebenge/Assets/images/ruleEndIcon.png") setget set_icon
export(Texture) var iconOff:Texture = load("res://GameDVDCardtridge/Tebenge/Assets/images/forbiddenIcon.png") setget set_iconOff
export(bool) var state = true setget set_state
onready var theLabel = $BoolLabel
onready var theCheck = $CheckButton
#onready var theIcon = $Horizontale/Icon

func _ready() -> void:
	theLabel.set_deferred("text",title)
	theCheck.set_deferred("text",value)
	theCheck.set_deferred("icon",icon if theCheck.pressed else iconOff)
#	theIcon.set_deferred("texture",icon)
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

func set_icon(into:Texture):
	icon = into
#	if theIcon != null:
#		theIcon.set_deferred("texture",icon)
	if theCheck != null:
		theCheck.set_deferred("icon",icon if theCheck.pressed else iconOff)

func set_iconOff(into:Texture):
	iconOff = into
#	if theIcon != null:
#		theIcon.set_deferred("texture",icon)
	if theCheck != null:
		theCheck.set_deferred("icon",icon if theCheck.pressed else iconOff)

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
		theCheck.set_deferred("icon",icon if theCheck.pressed else iconOff)
	pass

func _on_CheckButton_toggled(button_pressed: bool) -> void:
	set_state(button_pressed)
	pass # Replace with function body.
