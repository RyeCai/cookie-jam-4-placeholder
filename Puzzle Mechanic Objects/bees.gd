extends CharacterBody2D

### Stores the body to follow
var target

### Stores beehive ref
var beehive

###Stores vector direction to follow
var direction_to_body

var bee_speed := 30.0

func _physics_process(delta: float) -> void:
    if target:
        direction_to_body = (target.global_position - self.global_position).normalized()
    
    if direction_to_body:
        velocity = direction_to_body * bee_speed
        move_and_slide()


func _on_timer_timeout() -> void:
    beehive.current_bees -= 1
    queue_free()


func _on_hurt_area_body_entered(body: Node2D) -> void:
    if (body.is_in_group("Bird")) or (body.is_in_group("Pangolin") and body is CharacterBody2D):
        get_tree().reload_current_scene()
