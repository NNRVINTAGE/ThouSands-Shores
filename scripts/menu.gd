extends Control

@onready var player: Node3D = $"../ProtoController"
@onready var startbtn = $VBoxContainer/Start_btn
@onready var loadsbtn = $VBoxContainer/load_btn
@onready var start_menu = $"."

func _ready() -> void:
	startbtn.pressed.connect(Callable(self, "_startbtn_pressed"))
	loadsbtn.pressed.connect(Callable(self, "_loadsbtn_pressed"))

func _process(delta: float) -> void:
	var pos: Vector3 = player.global_transform.origin
	var rot: Vector3 = player.rotation
	var rot_deg: Vector3 = player.rotation_degrees

func close_startmn():
	start_menu.hide()

func _startbtn_pressed():
	save_object_data(player)
	load_object_data(player)
	start_menu.hide()

func _loadsbtn_pressed():
	load_object_data(player)
	start_menu.hide()

func save_object_data(obj: Node3D, filename: String = "obj_data.json") -> void:
	var dir := DirAccess.open("user://")
	if dir == null:
		DirAccess.make_dir_absolute("user://datas")
	else:
		if not dir.dir_exists("datas"):
			dir.make_dir("datas")

	var data := {
		"position": obj.global_transform.origin,
		"rotation": obj.rotation_degrees
	}

	var file_path := "user://datas/" + filename
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		print("Saved object data to: ", file_path)
	else:
		push_error("Could not open file for writing: " + file_path)

func load_object_data(obj: Node3D, filename: String = "obj_data.json") -> void:
	var file_path := "user://datas/" + filename
	if not FileAccess.file_exists(file_path):
		push_error("File not found: " + file_path)
		return

	var file := FileAccess.open(file_path, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	var result = JSON.parse_string(text)
	if typeof(result) == TYPE_DICTIONARY:
		obj.global_transform.origin = result["position"]
		obj.rotation_degrees = result["rotation"]
		print("Data Loaded!")
