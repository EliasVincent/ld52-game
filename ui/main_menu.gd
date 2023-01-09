extends Control
@onready var accept_dialog = $AcceptDialog

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://level_1.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	accept_dialog.visible = !accept_dialog.visible
