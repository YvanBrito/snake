class_name Snake
extends Node2D

const PIECE = preload("uid://bjpvdais1vc57")
const HEAD = preload("uid://yba2sslesdq2")
@onready var area_2d: Area2D = $Area2D
@onready var _timer: Timer = $"../WalkSnakeTime"
@onready var manager: Manager = $".."

var pieces: Array[Node2D]
var direction: Vector2 = Vector2.RIGHT
var previous_pos: Vector2
var last_position: Vector2
var local_when_input: Vector2 = Vector2.ZERO
var intervalo_ms: int = 100

func _ready() -> void:
	_timer.timeout.connect(_on_timeout)
	start_new_game()

func start_new_game() -> void:
	if pieces.size() > 0:
		for i in range(0, pieces.size()):
			pieces[i].queue_free()
	pieces = []
	var head = HEAD.instantiate()
	head.position = Vector2.ZERO
	pieces.push_back(head)
	add_child(head)
	manager.food_eaten()

func _on_timeout() -> void:
	previous_pos = pieces[0].position
	pieces[0].position += direction * manager.piece_size
	if pieces[0].position.x > manager.right_limit:
		pieces[0].position.x = manager.left_limit
	if pieces[0].position.x < manager.left_limit:
		pieces[0].position.x = manager.right_limit
	if pieces[0].position.y > manager.bottom_limit:
		pieces[0].position.y = manager.upper_limit
	if pieces[0].position.y < manager.upper_limit:
		pieces[0].position.y = manager.bottom_limit
	area_2d.position = pieces[0].position
	if direction == Vector2.LEFT:
		pieces[0].rotation_degrees = 0
	if direction == Vector2.UP:
		pieces[0].rotation_degrees = 90
	if direction == Vector2.RIGHT:
		pieces[0].rotation_degrees = 180
	if direction == Vector2.DOWN:
		pieces[0].rotation_degrees = 270
	for i in range(1, pieces.size()):
		var aux = pieces[i].position
		pieces[i].position = previous_pos
		previous_pos = aux
		if pieces[0].position == pieces[i].position:
			start_new_game()
			break
	last_position = previous_pos
	
func _input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		if (direction == Vector2.UP or direction == Vector2.DOWN) and event.is_action_pressed("ui_left"):
			_timer.start()
			_on_timeout()
			direction = Vector2.LEFT
		elif (direction == Vector2.UP or direction == Vector2.DOWN) and event.is_action_pressed("ui_right"):
			_timer.start()
			_on_timeout()
			direction = Vector2.RIGHT
		elif (direction == Vector2.LEFT or direction == Vector2.RIGHT) and event.is_action_pressed("ui_up"):
			_timer.start()
			_on_timeout()
			direction = Vector2.UP
		elif (direction == Vector2.LEFT or direction == Vector2.RIGHT) and event.is_action_pressed("ui_down"):
			_timer.start()
			_on_timeout()
			direction = Vector2.DOWN


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Food":
		var piece = PIECE.instantiate()
		piece.position = last_position
		pieces.push_back(piece)
		add_child(piece)
		manager.food_eaten()
