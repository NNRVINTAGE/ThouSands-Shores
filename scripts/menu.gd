extends Control

@onready var player: Node3D = $"../ProtoController"
@onready var startbtn = $VBoxContainer/Start_btn
@onready var loadsbtn = $VBoxContainer/load_btn
@onready var start_menus = $"."

func _ready():
	print("game started")
	startbtn.pressed.connect(Callable(self, "_startbtn_pressed"))
	loadsbtn.pressed.connect(Callable(self, "_loadsbtn_pressed"))

func _startbtn_pressed():
	print("pressed start")
	new_game_data(player)
	load_object_data(player)
	start_menus.hide()

func _loadsbtn_pressed():
	print("pressed load")
	load_object_data(player)
	start_menus.hide()

func new_game_data(obj: Node3D, filename: String = "obj_data.json") -> void:
	var dir := DirAccess.open("user://")
	if dir == null:
		DirAccess.make_dir_absolute("user://datas")
	else:
		if not dir.dir_exists("datas"):
			dir.make_dir("datas")

	var data := {
		"position": [obj.global_transform.origin.x, obj.global_transform.origin.y, obj.global_transform.origin.z],
		"rotation": [obj.rotation_degrees.x, obj.rotation_degrees.y, obj.rotation_degrees.z]
	}
	var file_path := "user://datas/" + filename
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		print("Saved object data to: ", file_path)
	else:
		push_error("Could not open file for writing: " + file_path)

func save_object_data(obj: Node3D, filename: String = "obj_data.json") -> void:
	var dir := DirAccess.open("user://")
	if dir == null:
		DirAccess.make_dir_absolute("user://datas")
	else:
		if not dir.dir_exists("datas"):
			dir.make_dir("datas")

	# Convert to arrays
	var data := {
		"position": [obj.global_transform.origin.x, obj.global_transform.origin.y, obj.global_transform.origin.z],
		"rotation": [obj.rotation_degrees.x, obj.rotation_degrees.y, obj.rotation_degrees.z]
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
		var pos_arr: Array = result["position"]
		var rot_arr: Array = result["rotation"]

		obj.global_transform.origin = Vector3(pos_arr[0], pos_arr[1], pos_arr[2])
		obj.rotation_degrees = Vector3(rot_arr[0], rot_arr[1], rot_arr[2])
		print("Data Loaded!")
