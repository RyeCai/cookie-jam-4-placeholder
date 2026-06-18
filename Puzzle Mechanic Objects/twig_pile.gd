extends Area2D

var able_to_peck = false

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("Bird"):
        able_to_peck = true
        

func _on_body_exited(body: Node2D) -> void:
    if body.is_in_group("Bird"):
        able_to_peck = false
        
func _process(_delta: float) -> void:
    if able_to_peck == true:
        if Input.is_action_just_pressed("bird_peck"):
            queue_free()
