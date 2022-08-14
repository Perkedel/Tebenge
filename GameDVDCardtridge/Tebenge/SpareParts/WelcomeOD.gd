extends BaseOD

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var leftLoadSay = $"%LeftLoadingLabel"
onready var rightLoadSay = $"%RightLoadingLabel"
var LoadSayRightNow:String = "-"
var loadSays:PoolStringArray = ['-', '\\', '|', '/']
var loadSayCount = 0;
var loadSayReady = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	yield(get_tree().create_timer(1), "timeout")
	loadSayReady = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if loadSayReady:
		leftLoadSay.text = loadSays[loadSayCount]
		rightLoadSay.text = loadSays[loadSayCount]
		loadSayCount += 1
		if loadSayCount > loadSays.size()-1:
			loadSayCount = 0
	pass
