extends StaticBody2D

## Amount of velocity the pangolin needs to have in order to break this object
@export var velocity_threshold: float


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.linear_velocity.length() * body.mass > velocity_threshold:
        $AnimationPlayer.play("Destroy")
        
