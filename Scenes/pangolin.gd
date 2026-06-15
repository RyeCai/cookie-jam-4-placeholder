extends CharacterBody2D

signal controls_on(character: CharacterBody2D)

const SPEED = 150.0
const FRICTION = 15.0
const JUMP_VELOCITY = -400.0

var disabled: bool 
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D #Reference to sprite sheet for flipping based on x speed
@export var camera: Camera2D


func _ready() -> void:
	sprite.play("idle")
	disabled = true
	$RemoteTransform2D.remote_path = camera.get_path()
	$RemoteTransform2D.update_position = false
	#camera.done_moving.connect(_on_camera_2d_done_moving)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#if Input.is_action_just_pressed("switch_char") and !$RemoteTransform2D.remote_path:
		#$RemoteTransform2D.remote_path = camera.get_path()
	if Input.is_action_just_pressed("switch_char"):
			if !disabled:
				velocity.x = 0
			else:
				controls_on.emit(self)
			disabled = !disabled
			$RemoteTransform2D.update_position = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("pango_left", "pango_right")

	#Calls functions to update sprite movement
	_check_for_sprite_move(direction)
	#Need to put this here due to ordering of animations
	if not is_on_floor():
		sprite.play("jump")
	if !disabled:
		# Handle jump.
		if Input.is_action_just_pressed("pango_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if direction:
			#velocity.x = direction * SPEED
			#Added this line to smooth the movement a bit- feels better when approaching ledges
			velocity.x = lerp(velocity.x, direction * SPEED, FRICTION * delta)
		else:
			#This might be able to be replaced with lerp but we'll leave it for now
			velocity.x = move_toward(velocity.x, 0, SPEED)
		

	move_and_slide()


#This function checks for sprite movement to determine animation AND the sprite flip
func _check_for_sprite_move(direction):
	#This cannot be an if/else or else a sprite flip will be forced
	if direction and !disabled:
		sprite.play("walk")

		if direction < 0:
			sprite.flip_h = true

		if direction > 0:
			sprite.flip_h = false

	else:
		sprite.play("idle")


func _on_camera_2d_done_moving() -> void:
	if !disabled:
		$RemoteTransform2D.update_position = true
	else:
		$RemoteTransform2D.update_position = false
