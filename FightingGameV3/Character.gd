extends Node2D

onready var stage = get_parent()
onready var area = $CollisionBox
onready var collider = $CollisionBox/CollisionShape

var playerNum: int
var opponent
var facing: int

## Change character speed here
const speed = 30
const gravity = 5
const jump = 75
var xMotion: int = 0
var yMotion: int = 0

func _ready():
	if playerNum == 2:
		modulate = Color("b2b2b2")

func _physics_process(delta):
	yMotion += gravity
	
	if Input.is_action_pressed("P"+str(playerNum)+"_Left") and !Input.is_action_pressed("P"+str(playerNum)+"_Right"):
		xMotion = -speed
	elif Input.is_action_pressed("P"+str(playerNum)+"_Right") and !Input.is_action_pressed("P"+str(playerNum)+"_Left"):
		xMotion = speed
	else:
		xMotion = lerp(xMotion, 0, 0.2)
	
	if Input.is_action_just_pressed("P"+str(playerNum)+"_Up"):
		yMotion = -jump
	
	
	global_position.x += xMotion
	global_position.y += yMotion
	
	character_collision()
	correct_position()
	get_facing()

func get_facing():
	var distance = opponent.global_position.x - global_position.x
	if distance != 0:
		facing = sign(distance)

func character_collision():
	if area.is_colliding():
		var spacing = collider.shape.extents.x + opponent.collider.shape.extents.x
		var distance = abs(opponent.global_position.x - global_position.x)
		var overlap = spacing - distance
		if overlap > 1:
			if opponent.on_wall() and !on_wall():
				global_position.x -= overlap * facing
			elif opponent.on_wall() and on_wall() and global_position.y < opponent.global_position.y:
				global_position.x -= overlap * facing
			else:
				global_position.x -= (overlap/2 * facing)
				opponent.global_position.x += (overlap/2 * facing)

func on_wall():
	return global_position.x - collider.shape.extents.x <= stage.leftLimit or global_position.x + collider.shape.extents.x >= stage.rightLimit

func correct_position():
	if global_position.x - collider.shape.extents.x < stage.leftLimit:
		global_position.x = stage.leftLimit + collider.shape.extents.x
	
	if global_position.x + collider.shape.extents.x > stage.rightLimit:
		global_position.x = stage.rightLimit - collider.shape.extents.x
	
	if global_position.y > stage.groundLimit:
		global_position.y = stage.groundLimit
	
	global_position.x = stepify(global_position.x, 1)
