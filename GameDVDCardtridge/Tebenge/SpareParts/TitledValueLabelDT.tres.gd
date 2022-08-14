tool
extends ComplexDT

class_name TitledValueLabelDT
export(String) var title = "Title" setget set_title
export(String) var value = "value" setget set_value
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
#var isReady:bool = false

func set_title(into:String):
#	if isReady:
		title = into
		if $TitleLabel != null:
			$TitleLabel.text = title

func set_value(into:String):
#	if isReady:
		value = into
		if $ValueLabel != null:
			$ValueLabel.text = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	isReady = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	$TitleLabel.text = title
#	$ValueLabel.text = value
	pass
