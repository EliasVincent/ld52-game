extends Node3D

@onready var cropTooltip = %DepositTooltip
@onready var cropsSaved: RichTextLabel = %CropsSaved
@onready var cropsHeld: RichTextLabel = %CropsHeld
@onready var harvest_tooltip = %HarvestTooltip
@onready var harvesting = %Harvesting
@onready var level_countdown: Timer = $LevelCountdown
@onready var time_text = %TimeText


@onready var player: CharacterBody3D = $Player


# Called when the node enters the scene tree for the first time.

func toggleDepositTooltip():
	cropTooltip.visible = !cropTooltip.visible

func toggleHarvestTooltip():
	harvest_tooltip.visible = !harvest_tooltip.visible
func harvestTooltipEnabled():
	harvest_tooltip.visible = true
func harvestTooltipDisabled():
	harvest_tooltip.visible = false

func toggleHarvesting():
	harvesting.visible = !harvesting.visible

func harvestingEnabled():
	harvesting.visible = true

func harvestingDisabled():
	harvesting.visible = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	cropsSaved.text = str("Crops saved: " , Globals.totalCrops)
	cropsHeld.text = str("Crops held: " , Globals.cropsHeld)
	time_text.text = str(snapped(level_countdown.time_left, 1))


func _on_level_countdown_timeout():
	pass # GAME OVER
