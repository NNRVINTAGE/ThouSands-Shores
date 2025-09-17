extends StaticBody3D

@export var target_position: Vector3   # Coordinates to teleport to
@export var cooldown_time := 0.5       # Prevent instant back teleport
var can_teleport := true

# Get the path to the player based on where it's located
var player: Node = null

func _ready():
	player = get_node_or_null("/root/Scene/mains/ProtoController")  # Correct path here
	if player == null:
		print("Player not found!")
		return
		
	var timer := 5
	await get_tree().create_timer(timer).timeout
	_teleport_player()

func _teleport_player():
	print("Teleporting", player.name, "to", target_position)
	player.global_transform.origin = target_position
	can_teleport = false
	# Cooldown to prevent instant re-teleport
	await get_tree().create_timer(cooldown_time).timeout
	can_teleport = true
