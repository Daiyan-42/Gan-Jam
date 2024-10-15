extends Control

func _ready():
	$VBoxContainer/StartButton.grab_focus() #for keyboard control


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_1.tscn") #go to first level



func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/main/options.tscn") #go to options scene
