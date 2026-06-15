extends Camera2D

signal done_moving

@export var panning_speed: float = 12.0
var current_char: CharacterBody2D
var camera_moving: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("switch_char"):
		#camera_moving = true
		#if current_char == bird:
			#current_char = pango
		#else:
			#current_char = bird
	if camera_moving:
		#var weight = 1 - exp(-panning_speed * delta)
		var interpolated_pos: Vector2 = position.lerp(current_char.position, delta*panning_speed)
		position = interpolated_pos
		# camera currently stops moving at an arbitrary value
		if abs(interpolated_pos.length() - current_char.position.length()) < 0.12:
			done_moving.emit()
			camera_moving = false


func _on_pangolin_controls_on(pango_transform: CharacterBody2D) -> void:
	current_char = pango_transform
	camera_moving = true


func _on_bird_controls_on(bird_transform: CharacterBody2D) -> void:
	current_char = bird_transform
	camera_moving = true
