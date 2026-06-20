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
var ball_on_floor: bool
var ball_instance: RigidBody2D

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
var jump_sound = preload("res://SFX/jump_MIX.wav")
var ball_form_sound = preload("res://SFX/armorshing_MIX.wav")
var ball_roll_sound = preload("res://SFX/rolling.wav")
var walk_sound = preload("res://SFX/grass_walking.wav")


func _ready() -> void:
    sprite.play("idle")
    controls_disabled = true
    $RemoteTransform2D.remote_path = camera.get_path()
    $RemoteTransform2D.update_position = false
    ball_mode = false


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
            ball_instance.queue_free()
            $CollisionShape2D.set_deferred("disabled", false)
            $AnimatedSprite2D.visible = true
            $RemoteTransform2D.global_position = pos_snapshot
            audio_player.pitch_scale = 1.0
        else:
            $CollisionShape2D.set_deferred("disabled", true)
            $AnimatedSprite2D.visible = false
            ball_instance = pango_ball_scene.instantiate()
            ball_instance.linear_velocity = velocity
            ball_instance.add_to_group("Pangolin")
            ball_instance.get_node("FloorCheck").body_entered.connect(_on_ball_body_entered)
            ball_instance.get_node("FloorCheck").body_exited.connect(_on_ball_body_exited)
            add_child(ball_instance)
        ball_mode = not ball_mode
        audio_player.stream = ball_form_sound
        audio_player.play()
        ###
    
    if ball_mode:
        $RemoteTransform2D.position = ball_instance.position
        if audio_player.stream != ball_roll_sound and not audio_player.playing:
            audio_player.stream = ball_roll_sound
        if not audio_player.playing and $Ball.linear_velocity.x > 0 and ball_on_floor:
            audio_player.pitch_scale = clampf($Ball.linear_velocity.length()/SPEED, 0.5, 1.5)
            audio_player.play()
        elif audio_player.stream != ball_roll_sound and $Ball.linear_velocity.x <= 0:
            audio_player.stop()
    else:        
        # Add the gravity.
        if not is_on_floor():
            velocity += get_gravity() * delta
        # Get the input direction and handle the movement/deceleration.
        # As good practice, you should replace UI actions with custom gameplay actions.
        var direction := Input.get_axis("move_left", "move_right")

        #Calls functions to update sprite movement
        _check_for_sprite_move(direction)
        #Need to put this here due to ordering of animations
        if not is_on_floor():
            if audio_player.stream == walk_sound:
                audio_player.stop()
            sprite.play("jump")
        if not controls_disabled:
            # Handle jump.
            if Input.is_action_just_pressed("jump") and is_on_floor():
                velocity.y = JUMP_VELOCITY
                ### Audio for ball
                audio_player.stream = jump_sound
                audio_player.play()
                ###

            if direction:
                #velocity.x = direction * SPEED
                #Added this line to smooth the movement a bit- feels better when approaching ledges
                velocity.x = lerp(velocity.x, direction * SPEED, FRICTION * delta)
                if not audio_player.playing and is_on_floor():
                    audio_player.stream = walk_sound
                    audio_player.play()
            else:
                #This might be able to be replaced with lerp but we'll leave it for now
                if audio_player.stream == walk_sound:
                    audio_player.stop()
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

func _on_ball_body_entered(_body: Node2D):
    ball_on_floor = true
    print("floor")


func _on_ball_body_exited(_body: Node2D):
    ball_on_floor = false
    

func _on_camera_2d_done_moving() -> void:
    if not controls_disabled:
        $RemoteTransform2D.update_position = true
    else:
        $RemoteTransform2D.update_position = false
        
