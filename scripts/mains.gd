extends Node3D

@onready var settings_menu = $SettingsMenu
@onready var start_menu = $StartMenu
@export var settings_ui : String = "ui_cancel"
@export var starting_keys : String = "ui_accept"

func _ready():
	start_menu.show() # open the satrt menus
	settings_menu.hide() # hide the settings just in case i forgot

func _input(event):
	if event.is_action_pressed(settings_ui):
		if settings_menu.visible:
			close_stgs()
		else:
			open_stgs()

#idk i would change this if needed
func open_stgs():
	settings_menu.show()

func close_stgs():
	settings_menu.hide()

func close_startmn():
	start_menu.hide()
