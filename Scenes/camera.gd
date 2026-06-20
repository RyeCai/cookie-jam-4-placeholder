extends Camera2D

signal done_moving

@export var panning_speed: float = 7.0
@onready var pangolin: CharacterBody2D = $"../Pangolin"
@onready var bird: CharacterBody2D = $"../Bird"
var current_char: CharacterBody2D
var camera_moving: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pangolin.controls_on.connect(_on_pangolin_controls_on)
    bird.controls_on.connect(_on_bird_controls_on)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if camera_moving:
        # Code meant to get position for when Pango is a ball or not
        var camera_speed: float
        var pos: Vector2
        if current_char.has_node("Ball"):
            var ball_node: RigidBody2D = current_char.get_node("Ball")
            # Account for character speed when moving the camera
            camera_speed = delta * (panning_speed+ball_node.linear_velocity.length()) 
            pos = ball_node.global_position
        else:
            # clamp used to limit speed when jumping
            camera_speed = delta * (panning_speed+clampf(current_char.velocity.length(), 0, 150))
            pos = current_char.position  
        var interpolated_pos: Vector2 = position.lerp(pos, camera_speed)
        position = interpolated_pos
        # camera currently stops moving at an arbitrary value
        if abs(interpolated_pos.length() - current_char.position.length()) < 0.08:
            done_moving.emit()
            camera_moving = false


func _on_pangolin_controls_on(pango_transform: CharacterBody2D) -> void:
    current_char = pango_transform
    camera_moving = true


func _on_bird_controls_on(bird_transform: CharacterBody2D) -> void:
    current_char = bird_transform
    camera_moving = true
