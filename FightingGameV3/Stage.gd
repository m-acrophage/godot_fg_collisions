extends Node
class_name Stage

var player1Path: String = "res://Sword.tscn"
var player2Path: String = "res://Sword.tscn"
var player1
var player2

onready var camera = $Camera2D
onready var cameraDefault: Vector2 = camera.global_position #Camera's strarting position
const groundLimit: int = 0 #Ground y position
var leftLimit: int #Left wall
var rightLimit: int #Right wall
const wallBuffer: int = 35 #Sets how close to camera edge characters can move
const stageSize: int = 960 #Camera x boundary, determines stage size
const cameraRect: int = 960 #Camera width (use get viewport setting later)
const startPos: int = 350 #Starting position for characters (distance from center)
const xSmooth: float = 0.3 #Camera x smoothing
const ySmooth: float = 0.3 #Camera y smoothing

func _ready():
	spawn_characters()
	set_camera()

func _physics_process(delta):
	set_camera()

func spawn_characters():
	var player1Resource = load(player1Path)
	var player2Resource = load(player2Path)
	player1 = player1Resource.instance()
	player2 = player2Resource.instance()
	player1.global_position = Vector2(-startPos, groundLimit)
	player1.opponent = player2
	player1.playerNum = 1
	player2.global_position = Vector2(startPos, groundLimit)
	player2.opponent = player1
	player2.playerNum = 2
	add_child(player1)
	add_child(player2)

func set_camera(): #Set camera position and limits for character x positions
	var middlePoint = (player1.global_position + player2.global_position)/2
	camera.global_position.x = lerp(camera.global_position.x, middlePoint.x, xSmooth)
	if middlePoint.y < cameraDefault.y:
		camera.global_position.y = lerp(camera.global_position.y, middlePoint.y, ySmooth)
	else:
		camera.global_position.y = lerp(camera.global_position.y, cameraDefault.y, xSmooth)
	
	if camera.global_position.x < -stageSize:
		camera.global_position.x = -stageSize
	if camera.global_position.x > stageSize:
		camera.global_position.x = stageSize
	
	leftLimit = camera.global_position.x - cameraRect + wallBuffer
	rightLimit = camera.global_position.x + cameraRect - wallBuffer
