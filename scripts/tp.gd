extends Area3D

@export var target_position: Vector3 = Vector3.ZERO
@export var require_group: String = "player"  # Only teleport nodes in this group

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group(require_group):
		return
	
	if body is Node3D:
		body.global_position = target_position
