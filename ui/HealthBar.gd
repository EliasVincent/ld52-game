extends Control

@onready var s0 = $"Container/0"
@onready var s1 = $"Container/1"
@onready var s2 = $"Container/2"
@onready var s3 = $"Container/3"
@onready var s4 = $"Container/4"
@onready var s5 = $"Container/5"
@onready var s6 = $"Container/6"
@onready var s7 = $"Container/7"
@onready var s8 = $"Container/8"
@onready var s9 = $"Container/9"

var arr: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	arr.append(s0)
	arr.append(s1)
	arr.append(s2)
	arr.append(s3)
	arr.append(s4)
	arr.append(s5)
	arr.append(s6)
	arr.append(s7)
	arr.append(s8)
	arr.append(s9)
	print(arr[0], arr[1])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match Globals.playerHp:
		#0:
		#	for i in arr:
		#		if i != s0:
		#			i.set_visible = false
		#	s0.set_visible = true
		1:
			for i in arr:
				if i != s9:
					i.visible = false
			s9.visible = true
		2:
			for i in arr:
				if i != s2:
					i.visible = false
			s2.visible = true
		3:
			for i in arr:
				if i != s3:
					i.visible = false
			s3.visible = true
		4:
			for i in arr:
				if i != s4:
					i.visible = false
			s4.visible = true
		5:
			for i in arr:
				if i != s5:
					i.visible = false
			s5.visible = true
		6:
			for i in arr:
				if i != s6:
					i.visible = false
			s6.visible = true
		7:
			for i in arr:
				if i != s7:
					i.visible = false
			s7.visible = true
		8:
			for i in arr:
				if i != s8:
					i.visible = false
			s8.visible = true
		9:
			for i in arr:
				if i != s9:
					i.visible = false
			s9.visible = true
		_:
			for i in arr:
				if i != s0:
					i.visible = false
			s0.visible = true
