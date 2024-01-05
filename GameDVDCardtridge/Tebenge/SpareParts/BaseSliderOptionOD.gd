tool
extends BaseOD

export(String) var title:String = "Value Slider" setget set_title
export(float) var value:float = 50 setget set_value
onready var theValueSliderDT = $ValueSliderDT
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func set_title(into:String):
	title = into
#	if $BoolLabel != null && $BoolLabel.is_inside_tree():
#		$BoolLabel.text = title
	if theValueSliderDT != null:
#		theLabel.text = title
		theValueSliderDT.set_deferred("title",title)

func set_value(into:float):
	value = into
	if theValueSliderDT != null:
		theValueSliderDT.set_deferred("value",value)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
