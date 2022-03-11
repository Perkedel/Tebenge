extends BaseLagrange


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.

func _readyCustom() -> void:
	pass

func setContinueNumber(say:String) -> void:
	$ContinueOD/ContinueIndicatorDT.value


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
