extends Node3D

@export var move_speed: float = 5.0  # mov speed m/s
var set_ops: Vector3
var origin_positns: Vector3
var start_position: Vector3
var target_position: Vector3
var moving: bool = false
var direction: int = 1

func _ready():
	set_ops = global_transform.origin
	origin_positns = set_ops

func _physics_process(delta: float) -> void:
	var distance_to_move = move_speed * delta
	if moving:
		var direction_vector = (target_position - global_transform.origin).normalized()
		global_transform.origin += direction_vector * distance_to_move
	if global_transform.origin.distance_to(target_position) <= distance_to_move:
		global_transform.origin = target_position  # Snap to target
		moving = false  # Stop moving

	# Trigger from other scripts, but ignores if already moving
func move_to_position(new_target: Vector3) -> void:
	if moving:
		return
	if target_position == start_position:
		target_position = new_target
		direction = 1
	else:
		start_position = global_transform.origin
		target_position = origin_positns
		direction = 1
	moving = true
