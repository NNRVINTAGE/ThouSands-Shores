extends Control

@onready var player: Node3D = $"../ProtoController"
@onready var volume_slider = $VBoxContainer/VolumeSlider
@onready var vsync_checkbox = $HBoxContainer/VsyncCheckBox
@onready var fps_spinbox = $HBoxContainer2/FpsSpinBox
@onready var ElevatorActivator = $VBoxContainer2/ElevatorActivator
@onready var savebtn = $VBoxContainer3/savebtn

const CONFIG_PATH = "user://settings.cfg"

func _ready():
	load_settings()

	ElevatorActivator.pressed.connect(Callable(self, "_activator_pressed"))
	savebtn.pressed.connect(Callable(self, "_save_object_data"))
	volume_slider.value_changed.connect(Callable(self, "_on_volume_changed"))
	vsync_checkbox.toggled.connect(Callable(self, "_on_vsync_toggled"))
	fps_spinbox.value_changed.connect(Callable(self, "_on_fps_changed"))


# --- SIGNAL CALLBACKS ---
func _save_object_data():
	var menu = get_node("../StartMenu")
	menu.save_object_data(player)
	
func _activator_pressed():
	var elev = get_node("../elevator")
	elev.move_to_position(Vector3(-460.0, -646.5, 459.0))

func _on_volume_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, value)
	save_settings()

func _on_vsync_toggled(pressed: bool) -> void:
	if pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	save_settings()

func _on_fps_changed(value: float) -> void:
	Engine.max_fps = int(value)
	save_settings()


# --- SAVE & LOAD ---
func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("graphics", "vsync", vsync_checkbox.button_pressed)
	config.set_value("graphics", "fps", Engine.max_fps)
	config.set_value("audio", "volume", volume_slider.value)
	config.save(CONFIG_PATH)

func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err == OK:
		# Load graphics
		if config.has_section_key("graphics", "vsync"):
			var vsync_on: bool = config.get_value("graphics", "vsync")
			vsync_checkbox.button_pressed = vsync_on
			if vsync_on:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			else:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		if config.has_section_key("graphics", "fps"):
			Engine.max_fps = int(config.get_value("graphics", "fps"))
			fps_spinbox.value = Engine.max_fps

		# Load audio
		if config.has_section_key("audio", "volume"):
			var vol = float(config.get_value("audio", "volume"))
			volume_slider.value = vol
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), vol)
	else:
		# Defaults if no config file
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		Engine.max_fps = 1000
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0.0)
