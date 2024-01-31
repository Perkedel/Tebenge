tool
extends ComplexDT

# do multidecker with flow????

export(String) var title:String = 'Double Decker Buttons' setget set_title
export(PoolStringArray) var buttonSays:PoolStringArray = ['Button A', 'Button B'] setget set_buttons
export(PoolStringArray) var buttonTips:PoolStringArray = ['',''] setget set_tips
export(Array) var buttonIcons:Array = [null,null]
onready var theLabel:Label = $DeckerName
onready var theButtons = [$MenuButtonA,$MenuButtonB]
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

signal pressedName(name)

func set_title(into:String):
	title = into
	if theLabel != null:
		theLabel.set_deferred('text',title)
	pass

func set_tips(into:PoolStringArray):
	buttonTips = into
	
	for buttone in range(into.size()):
		if theButtons != null:
			if theButtons[buttone] != null:
				theButtons[buttone].set_deferred('hint_tooltip',buttonTips[buttone])
				pass
	pass

func set_buttons(into:PoolStringArray):
	buttonSays = into
	
	for buttone in range(into.size()):
		if theButtons != null:
			if theButtons[buttone] != null:
				theButtons[buttone].set_deferred('text',buttonSays[buttone])
				pass
	pass

func set_Icons(into:Array):
	buttonIcons = into
	
	for buttone in range(into.size()):
		if theButtons != null:
			if theButtons[buttone] != null:
				theButtons[buttone].set_deferred('icon',buttonIcons[buttone] if buttonIcons[buttone] is Texture else null)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if theLabel != null:
		theLabel.set_deferred('text',title)
	
	for buttone in range(buttonSays.size()):
		if theButtons != null:
			if theButtons[buttone] != null:
				theButtons[buttone].set_deferred('text',buttonSays[buttone])
				pass
	
	for thingThere in get_children():
		if thingThere.has_signal("pressedName"):
#			print('konsac')
			thingThere.connect("pressedName", self, "sendPressedOption")
			pass
		pass
	pass # Replace with function body.

func sendPressedOption(named:String):
#	print("Pressed %s" % [named])
	emit_signal("pressedName",named)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
