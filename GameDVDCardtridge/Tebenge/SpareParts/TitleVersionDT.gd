tool
extends TitledValueLabelDT

const hardCodeVersion:String = Tebenge.VERSION
const savePath:String = "user://Simpan/Tebenge/Simpan.json"
const saveDir:String = "Simpan/Tebenge/"
const updateCheckDownloadMeURL:String = ""
const hiScoreArcadeId:String = "CgkIhru1tYoQEAIQAQ"
const hiScoreEndlessId:String = "CgkIhru1tYoQEAIQAw"
const startMeAchievement:String = "CgkIhru1tYoQEAIQAg"
const finishMeAchievement:String = "CgkIhru1tYoQEAIQBg"
const adMurderedAchievement:String = "CgkIhru1tYoQEAIQBA"
const leetSpeakAchievement:String = "CgkIhru1tYoQEAIQBQ"
const sixNineNiceAchievement:String = "CgkIhru1tYoQEAIQDQ"
const yesContinueAchievement:String = "CgkIhru1tYoQEAIQBw"
const noIGiveUpAchievement:String = "CgkIhru1tYoQEAIQCQ"
const abandonAchievment:String = "CgkIhru1tYoQEAIQCA"
const firstDuarAchievment:String = "CgkIhru1tYoQEAIQCg"
const fortyOfThemAchievment:String = "CgkIhru1tYoQEAIQDA"
const eikSerkatAmDeddAchievement:String = "CgkIhru1tYoQEAIQCw"
const tooLateContinueZeroAchievement:String = "CgkIhru1tYoQEAIQDw"
const wentPaidAchievement:String = "CgkIhru1tYoQEAIQEA"
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func readExportVerCode() -> String:
	# https://forum.godotengine.org/t/read-exported-version-code-from-gdscript/17920/3
	if OS.get_name() == "Android":
		var export_config: ConfigFile = ConfigFile.new()
		var err = export_config.load("res://export_presets.cfg")
		if err == OK:
			#print(export_config.get_value("preset.1.options", 'version/code'))
			#print(export_config.get_value("preset.1.options", 'version/name'))
			return export_config.get_value("preset.1.options", 'version/code')
		else:
			#print('[engine_root] Error open export_presets.cfgs')
			return '???'
	return '---'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = "v" + hardCodeVersion + ' (' + readExportVerCode() + ')'
	$ValueLabel.text = value
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
