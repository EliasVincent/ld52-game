extends Node

# Change the vars in level_1.gd too
var isFS = false
var totalCrops: int = 0
var cropsHeld: int = 0
var sprayAmmo: int = 4
var playerHp: int = 9
var maxHeld: int = 6

var cropsToCollect: int = 10

func _input(event):
	if Input.is_action_just_pressed("fullscreen"):
		if isFS:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			#ProjectSettings.set_setting("display/window/size/mode", "windowed")
			isFS = false
			OS
		else:
			#ProjectSettings.set_setting("display/window/size/mode", "fullscreen")
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			isFS = true
	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))

