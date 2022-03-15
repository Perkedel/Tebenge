tool
extends ComplexDT

export(String) var title = "Title" setget set_title
export(String) var value = "value" setget set_value
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func set_title(into:String):
	title = into
	$TitleLabel.text = title

func set_value(into:String):
	value = into
	$ValueLabel.text = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	$TitleLabel.text = title
#	$ValueLabel.text = value
	pass
