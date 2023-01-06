extends Node3D

@onready var cropTooltip = %DepositTooltip
@onready var cropsSaved: RichTextLabel = %CropsSaved
@onready var cropsHeld: RichTextLabel = %CropsHeld

@onready var player: CharacterBody3D = $Player


# Called when the node enters the scene tree for the first time.

func toggleDepositTooltip():
	cropTooltip.visible = !cropTooltip.visible

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cropsSaved.text = str("Crops saved: " , player.totalCrops)
	cropsHeld.text = str("Crops held: " , player.cropsHeld)
