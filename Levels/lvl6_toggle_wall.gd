extends StaticBody2D

@onready var pango_button: Node2D = $"../PangoButton"
@onready var bird_button: Node2D = $"../BirdButton"

@onready var wall_coll: CollisionShape2D = $CollisionShape2D
@onready var wall_sprite: NinePatchRect = $WallSprite
@onready var unlock_wall_noise: AudioStreamPlayer2D = $UnlockWallNoise

var task_complete : bool = false

func _process(_delta: float) -> void:
    if pango_button.button_pressed and bird_button.button_pressed and not task_complete:
        rotation += PI
        unlock_wall_noise.play()
        task_complete = true
    elif not pango_button.button_pressed or not bird_button.button_pressed:
        task_complete = false
