extends Button
@onready var credits_panel: Panel = $"../CreditsPanel"

func _ready() -> void:
    credits_panel.visible = false
    


func _on_pressed() -> void:
    credits_panel.visible = !credits_panel.visible
