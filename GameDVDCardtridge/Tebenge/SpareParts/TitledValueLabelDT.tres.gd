extends ComplexDT

export(String) var title = "Title"
export(String) var value = "value"
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TitleLabel.text = title
	$TitleLabel.text = value
	pass