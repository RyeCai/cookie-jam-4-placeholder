extends CharacterBody2D

signal controls_on(character: CharacterBody2D)

const SPEED = 150.0
const FRICTION = 15.0
const JUMP_VELOCITY = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D #Reference to sprite sheet for flipping based on x speed
@export var camera: Camera2D
@export var pango_ball_scene: PackedScene
var controls_disabled: bool 
var ball_mode: bool
var ball_instance: RigidBody2D


func _ready() -> void:
    sprite.play("idle")
    controls_disabled = true
    $RemoteTransform2D.remote_path = camera.get_path()
    $RemoteTransform2D.update_position = false
    ball_mode = false
    #camera.done_moving.connect(_on_camera_2d_done_moving)


func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("switch_char"):
        if not controls_disabled:
            velocity.x = 0
        else:
            controls_on.emit(self)
        controls_disabled = not controls_disabled
        $RemoteTransform2D.update_position = false
    
    if not controls_disabled and Input.is_action_just_pressed("pango_ball"):
        if ball_mode:
            var pos_snapshot: Vector2 = ball_instance.global_position
            position = ball_instance.global_position
            #ball_instance.call_deferred("queue_free")
            ball_instance.queue_free()
            $CollisionShape2D.set_deferred("disabled", false)
            $AnimatedSprite2D.visible = true
            $RemoteTransform2D.global_position = pos_snapshot
        else:
            $CollisionShape2D.set_deferred("disabled", true)
            $AnimatedSprite2D.visible = false
            ball_instance = pango_ball_scene.instantiate()
            add_child(ball_instance)
        ball_mode = not ball_mode
    
    # Add the gravity.
    if ball_mode:
        $RemoteTransform2D.position = ball_instance.position
    else:        
        if not is_on_floor():
            velocity += get_gravity() * delta
        # Get the input direction and handle the movement/deceleration.
        # As good practice, you should replace UI actions with custom gameplay actions.
        var direction := Input.get_axis("move_left", "move_right")

        #Calls functions to update sprite movement
        _check_for_sprite_move(direction)
        #Need to put this here due to ordering of animations
        if not is_on_floor():
            sprite.play("jump")
        if not controls_disabled:
            # Handle jump.
            if Input.is_action_just_pressed("move_up") and is_on_floor():
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
    if direction and not controls_disabled:
        sprite.play("walk")

		if direction < 0:
			sprite.flip_h = true

		if direction > 0:
			sprite.flip_h = false

	else:
		sprite.play("idle")


func _on_camera_2d_done_moving() -> void:
    if not controls_disabled:
        $RemoteTransform2D.update_position = true
    else:
        $RemoteTransform2D.update_position = false
