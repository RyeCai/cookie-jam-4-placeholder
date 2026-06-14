extends CharacterBody2D

const SPEED = 200.0
const FRICTION = 10.0
const JUMP_VELOCITY = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("fly")

func _physics_process(delta: float) -> void:
	# # Add the gravity.
	# if not is_on_floor():
	#     velocity += get_gravity() * delta

	# # Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#     velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("bird_left", "bird_right", "bird_up", "bird_down")
	direction = direction.normalized()
	
	_check_for_sprite_move(direction.x)
	
	#velocity = direction * SPEED
	velocity = lerp(velocity, direction * SPEED, FRICTION * delta)
	# if direction:
	#     velocity = direction * SPEED
	# else:
	#     velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	##Doesnt seem to work due to having no gravity- will leave for now (or maybe because of circular collision)
	#if is_on_floor():
		#sprite.play("idle")

	move_and_slide()
	
	

#This function checks for sprite movement to determine animation AND the sprite flip
func _check_for_sprite_move(direction):
	#This cannot be an if/else or else a sprite flip will be forced
	if direction < 0:
		sprite.flip_h = true
		
	if direction > 0:
		sprite.flip_h = false
