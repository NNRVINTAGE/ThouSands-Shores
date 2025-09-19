extends Node3D

@onready var settings_menu = $SettingsMenu
@export var settings_ui : String = "ui_cancel"

func _ready():
	settings_menu.hide() # start hidden

func _input(event):
	if event.is_action_pressed(settings_ui): # Esc by default
		if settings_menu.visible:
			close_settings()
		else:
			open_settings()

func open_settings():
	settings_menu.show()

func close_settings():
	settings_menu.hide()
