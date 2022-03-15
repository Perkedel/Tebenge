#tool

extends Control

export(Texture) var normal:Texture
export(Texture) var pressed:Texture
export(BitMap) var bitmask:BitMap
export(Shape2D) var shape:Shape2D
export(bool) var shape_centered:bool = true
export(bool) var shape_visible:bool = true
export(bool) var passby_press:bool = true
export(String) var action:String = ""

# VISIBILITY_ALWAYS = Always visible.
# VISIBILITY_TOUCHSCREEN_ONLY = Visible on touch screens only.
enum VisibilityMode {ALWAYS , TOUCHSCREEN_ONLY }

export(VisibilityMode) var visibility_mode = VisibilityMode.ALWAYS

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var button = $TouchScreenButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Marco Fazio's autohide
	if not OS.has_touchscreen_ui_hint() and visibility_mode == VisibilityMode.TOUCHSCREEN_ONLY:
		hide()
#	button.position = rect_position
	_setThese()
	pass # Replace with function body.

func _setThese():
	if button == null:
		return
	button.normal = normal
	button.pressed = pressed
	button.bitmask = bitmask
	button.shape = shape
	button.shape_centered = shape_centered
	button.shape_visible = shape_visible
	button.passby_press = passby_press
	button.action = action
	button.visibility_mode = visibility_mode
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		# Marco Fazio's autohide
		if not OS.has_touchscreen_ui_hint() and visibility_mode == VisibilityMode.TOUCHSCREEN_ONLY:
			if visible:
				hide()
		_setThese()
	pass
