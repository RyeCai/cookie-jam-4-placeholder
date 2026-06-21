extends Camera2D


@onready var pangolin: CharacterBody2D = $"../Pangolin"
@onready var bird: CharacterBody2D = $"../Bird"
var current_char: CharacterBody2D
var camera_moving: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pangolin.controls_on.connect(_on_pangolin_controls_on)
    bird.controls_on.connect(_on_bird_controls_on)


func _on_pangolin_controls_on(speed: float) -> void:
    position_smoothing_speed = speed/15


func _on_bird_controls_on(speed: float) -> void:
    position_smoothing_speed = speed/15
