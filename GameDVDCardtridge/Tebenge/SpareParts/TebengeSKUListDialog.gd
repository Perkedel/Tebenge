extends TebengeAcceptDialog

onready var theItemList = $SKUItemsLists
onready var placeheldIcon:Texture = preload("res://GameDVDCardtridge/Tebenge/Assets/images/appIcon.png")
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func readSKULists(items:Array = [],section:String=''):
	theItemList.clear()
	window_title = 'Items on shelf for ' + section
	for item in items:
		# http request image is async process!
		theItemList.add_item(item.sku + ' ('+ item.price + ')',placeheldIcon,true)
		pass
	popup_centered()
	pass

func readPurchasedLists(purchases:Array = [],section:String=''):
	theItemList.clear()
	window_title = 'Bought Items in ' + section
	for item in purchases:
		theItemList.add_item(item.sku + ' ('+ item.price + ')',placeheldIcon,true)
		pass
	popup_centered()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
