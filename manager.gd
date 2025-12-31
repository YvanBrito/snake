extends Node2D
class_name Manager

const FOOD = preload("uid://cihptc0jq45je")
var food: Area2D
var paused: bool = false

func _ready() -> void:
	randomize()
	food = FOOD.instantiate()
	var rx = rand_multiple_of_20(-560, 560)
	var ry = rand_multiple_of_20(-310, 310)
	food.position = Vector2(rx, ry)
	add_child(food)

func rand_multiple_of_20(min_int: int, max_int: int) -> int:
	# Garante ordem
	var a: int = min(min_int, max_int)
	var b: int = max(min_int, max_int)

	# Converte o intervalo para "passos" de 20
	var start_step := int(ceil(float(a) / 20.0))
	var end_step := int(floor(float(b) / 20.0))

	# Não existe múltiplo de 20 no intervalo
	if start_step > end_step:
		push_error("Não há múltiplos de 20 entre %d e %d" % [a, b])
		return start_step * 20 # fallback

	# Sorteia um passo inteiro e volta para múltiplo de 20
	var step := randi_range(start_step, end_step)
	return step * 20

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		paused = not paused
		Engine.time_scale = 0 if paused else 1

func food_eaten() -> void:
	if food:
		var rx = rand_multiple_of_20(-560, 560)
		var ry = rand_multiple_of_20(-310, 310)
		food.position = Vector2(rx, ry)
