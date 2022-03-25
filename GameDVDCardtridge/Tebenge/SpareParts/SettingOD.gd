extends BaseOD

var updating:bool = false

func _on_SoundOnOffDT_changeState(into:bool) -> void:
	if !updating:
		print("Change Mute %s" % [String(!into)])
		# https://godotengine.org/qa/24377/change-global-volume-in-3-0
	#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	#	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !into)
		$TestSpeaker.play()
	pass # Replace with function body.

func refreshSettingStatus():
	updating = true

	if AudioServer.get_bus_mute(AudioServer.get_bus_index("Master")):
		$SoundOnOffDT.set_pressed(true)
	else:
		$SoundOnOffDT.set_pressed(false)

	updating = false
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		refreshSettingStatus()
		pass
	pass
