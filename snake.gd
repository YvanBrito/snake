class_name Snake
extends Node2D

const PIECE = preload("uid://bjpvdais1vc57")
@onready var timer: Timer = $"../WalkSnakeTime"
@onready var area_2d: Area2D = $Area2D
@onready var manager: Manager = $".."

var pieces: Array[Node2D]
var direction: Vector2 = Vector2.RIGHT
var last_position: Vector2

func _ready() -> void:
	timer.timeout.connect(_on_timeout)
	start_new_game()

func start_new_game() -> void:
	timer.start()
	if pieces.size() > 0:
		for i in range(0, pieces.size()):
			pieces[i].queue_free()
	pieces = []
	var piece = PIECE.instantiate()
	piece.position = Vector2.ZERO
	pieces.push_back(piece)
	add_child(piece)
	manager.food_eaten()

func _on_timeout() -> void:	
	last_position = pieces[0].position
	pieces[0].position += direction * 20
	if pieces[0].position.x > 560:
		pieces[0].position.x = -560
	if pieces[0].position.x < -560:
		pieces[0].position.x = 560
	if pieces[0].position.y > 300:
		pieces[0].position.y = -300
	if pieces[0].position.y < -300:
		pieces[0].position.y = 300
	area_2d.position = pieces[0].position
	for i in range(1, pieces.size()):
		var aux = pieces[i].position
		pieces[i].position = last_position
		last_position = aux
		if pieces[0].position == pieces[i].position:
			timer.stop()
			start_new_game()
			break
	
func _input(event: InputEvent) -> void:
	if (direction == Vector2.UP or direction == Vector2.DOWN) and event.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	elif (direction == Vector2.UP or direction == Vector2.DOWN) and event.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	elif (direction == Vector2.LEFT or direction == Vector2.RIGHT) and event.is_action_pressed("ui_up"):
		direction = Vector2.UP
	elif (direction == Vector2.LEFT or direction == Vector2.RIGHT) and event.is_action_pressed("ui_down"):
		direction = Vector2.DOWN


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Food":
		var piece = PIECE.instantiate()
		piece.position = Vector2(pieces[-1].position.x - 20, pieces[-1].position.y)
		pieces.push_back(piece)
		add_child(piece)
		manager.food_eaten()
