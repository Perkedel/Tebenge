extends BaseOD

class_name DisableAdsOD
onready var theBuyMonth:Button = $Buy1MonthButton
onready var theDisableBoughtDT = $AdDisabledLabelDT
onready var theAdPriceDT = $AdDisablePriceDT
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func congratulationAdDisabled(yes:bool = true):
	theBuyMonth.visible = not yes
	theDisableBoughtDT.visible = yes
	pass

func adPriceInfo(info:Dictionary):
	if info.has('price'):
		theAdPriceDT.set_value(info.price)
	if info.has('subbed'):
		pass
	pass
