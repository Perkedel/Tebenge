tool
extends ComplexDT

export(String) var title:String = "Action" setget set_title
export(String) var action:String = "ui_cancel" setget set_actionName
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var titleThing = $Title
onready var actionIcon = $ActionIcon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if titleThing != null:
		titleThing.text = title
	if actionIcon != null:
		actionIcon.action_name = action
	pass # Replace with function body.

func set_title(into:String):
	title = into
	if titleThing != null:
		titleThing.text = title

func set_actionName(into:String):
	action = into
	if actionIcon != null:
		actionIcon.action_name = action

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
