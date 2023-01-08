extends Node3D

@onready var cropTooltip = %DepositTooltip
@onready var cropsSaved: RichTextLabel = %CropsSaved
@onready var cropsHeld: RichTextLabel = %CropsHeld
@onready var harvest_tooltip = %HarvestTooltip
@onready var harvesting = %Harvesting
@onready var level_countdown: Timer = $LevelCountdown
@onready var time_text = %TimeText


@onready var player: CharacterBody3D = $Player

var cropNodes = []
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
	# initialize vars
	Globals.totalCrops = 0
	Globals.cropsHeld = 0
	Globals.sprayAmmo = 5
	Globals.playerHp = 9
	
	var allCrops = 0
	cropNodes = get_tree().get_nodes_in_group("CROPOBJECT")
	for i in cropNodes:
		allCrops += 1
	Globals.cropsToCollect = allCrops
	print(Globals.cropsToCollect)

func _process(delta):
	cropsSaved.text = str("Crops saved: " , Globals.totalCrops)
	cropsHeld.text = str("Crops held: " , Globals.cropsHeld)
	time_text.text = str(snapped(level_countdown.time_left, 1))
	
	if Globals.totalCrops == Globals.cropsToCollect:
		get_tree().change_scene_to_file("res://ui/win_screen.tscn")


func _on_level_countdown_timeout():
	get_tree().change_scene_to_file("res://ui/game_over.tscn")
