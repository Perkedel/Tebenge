tool
extends ComplexDT

export(String) var title:String = "Value Slider" setget set_title
export(float) var value:float = 50 setget set_value
onready var theLabel:Label = $ContainsWextra/ValueName
onready var theValueDisplay:Label = $ContainsWextra/ValueOfIt
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func set_title(into:String):
	title = into
#	if $BoolLabel != null && $BoolLabel.is_inside_tree():
#		$BoolLabel.text = title
	if theLabel != null:
#		theLabel.text = title
		theLabel.set_deferred("text",title)

func set_value(into:float):
	value = into
	if theValueDisplay != null:
		theValueDisplay.set_deferred('text',_getDisplayValue(value))
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	theLabel.set_deferred('text',title)
	theValueDisplay.set_deferred('text',_getDisplayValue(value))
	pass # Replace with function body.

func _getDisplayValue(input:float, decimal:bool = false, precision:int = 2)->String:
	return String(round(value* pow(10,precision)) / pow(10,precision) ) if decimal else String(round(value))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
