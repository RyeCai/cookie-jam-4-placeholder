extends StaticBody2D

@onready var pango_button: Node2D = $"../../PangoButton"


@onready var wall_coll: CollisionShape2D = $CollisionShape2D
@onready var wall_sprite: NinePatchRect = $WallSprite
@onready var unlock_wall_noise: AudioStreamPlayer2D = $UnlockWallNoise

var task_complete : bool = false

func _process(_delta: float) -> void:
    if task_complete == false:
        if pango_button.button_pressed == true:
            wall_sprite.visible = false
            wall_coll.disabled = true
            unlock_wall_noise.play()
            task_complete = true
