extends BaseOD

class_name DisableAdsOD
onready var theBuyMonth:Button = $Buy1MonthButton
onready var theDisableBoughtDT = $AdDisabledLabelDT
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func congratulationAdDisabled(yes:bool = true):
	theBuyMonth.visible = not yes
	theDisableBoughtDT.visible = yes
	pass
