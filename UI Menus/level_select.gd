extends VBoxContainer


func _on_button_level_one_pressed() -> void:
    get_tree().change_scene_to_file("res://Levels/LevelOneProto.tscn")


func _on_button_level_two_pressed() -> void:
    get_tree().change_scene_to_file("res://Levels/LevelTwoProto.tscn")


func _on_button_level_three_pressed() -> void:
    get_tree().change_scene_to_file("res://Levels/LevelThreeProto.tscn")


func _on_button_level_four_pressed() -> void:
    get_tree().change_scene_to_file("res://Levels/LevelFourProto.tscn")


func _on_button_level_five_pressed() -> void:
    get_tree().change_scene_to_file("res://Levels/LevelFiveProto.tscn")

func _on_button_level_six_pressed() -> void:
    get_tree().change_scene_to_file("res://Levels/LevelSixProto.tscn")
