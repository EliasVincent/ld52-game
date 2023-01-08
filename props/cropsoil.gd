extends StaticBody3D

@onready var catcrop = $catcrop
@onready var animation_player = $AnimationPlayer


var canBeHarvested: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func harvestAnim():
	animation_player.play("HARVESTING")

func setToHarvested():
	catcrop.visible = false
	canBeHarvested = false
