extends Control

@onready var play = $VBoxContainer/Play

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	play.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://level_1.tscn")


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
