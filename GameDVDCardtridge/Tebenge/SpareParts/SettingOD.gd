extends BaseOD

func _on_SoundOnOffDT_changeState(into:bool) -> void:
	print("Change Mute %s" % [String(!into)])
	# https://godotengine.org/qa/24377/change-global-volume-in-3-0
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
#	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !into)
	$TestSpeaker.play()
	pass # Replace with function body.
