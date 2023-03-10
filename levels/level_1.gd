extends Node3D

@onready var cropTooltip = %DepositTooltip
@onready var cropsSaved: RichTextLabel = %CropsSaved
@onready var cropsHeld: RichTextLabel = %CropsHeld
@onready var harvest_tooltip = %HarvestTooltip
@onready var harvesting = %Harvesting
@onready var level_countdown: Timer = $LevelCountdown
@onready var time_text = %TimeText
@onready var ammo = %Ammo
@onready var reload_tooltip = %ReloadTooltip



@onready var player: CharacterBody3D = $Player

var cropNodes = []
var numOfAllCrops: int = 0

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
	Globals.sprayAmmo = 4
	Globals.playerHp = 9
	
	var allCrops = 0
	cropNodes = get_tree().get_nodes_in_group("CROPOBJECT")
	for i in cropNodes:
		allCrops += 1
	Globals.cropsToCollect = allCrops
	numOfAllCrops = allCrops
	print(Globals.cropsToCollect)

func _process(delta):
	cropsSaved.text = str("Crops saved: " , Globals.totalCrops, "/", numOfAllCrops)
	cropsHeld.text = str("Crops held: " , Globals.cropsHeld, "/", Globals.maxHeld)
	time_text.text = str(snapped(level_countdown.time_left, 1))
	ammo.text = str("Ammo: ", Globals.sprayAmmo)
	
	if Globals.totalCrops >= Globals.cropsToCollect:
		get_tree().change_scene_to_file("res://ui/win_screen.tscn")
	
	if Globals.sprayAmmo <= 0:
		reload_tooltip.visible = true
	else:
		reload_tooltip.visible = false

func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_level_countdown_timeout():
	get_tree().change_scene_to_file("res://ui/game_over.tscn")
