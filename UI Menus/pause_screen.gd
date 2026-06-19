extends Control
@onready var win_screen: Control = $"../WinScreen"


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        
        self.visible = !self.visible
        
        ###Forces pause to go away if win screen is up
        if win_screen.visible == true:
            self.visible = false
