extends ComplexDT


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

signal pressedName(name)

func _on_PauseButton_pressedName(name) -> void:
	emit_signal("pressedName",name)
	pass # Replace with function body.
