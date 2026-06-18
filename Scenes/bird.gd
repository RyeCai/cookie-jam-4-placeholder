extends CharacterBody2D

signal controls_on(character: CharacterBody2D)
@onready var peck_anim_play: AnimationPlayer = $PeckAnimPlay
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
var peck_sound = preload("res://SFX/peck_MIX.wav")
var egg_sound = preload("res://SFX/peck_MIX.wav") #Needs to be updated nwith correct sound

const SPEED = 200.0
const FRICTION = 10.0
const JUMP_VELOCITY = -400.0

var controls_disabled: bool

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var camera: Camera2D

var bird_egg := preload("res://Scenes/BirdEgg.tscn")
var scene_root #Declares variable here to be later defined in ready function- holds the root node of current scene

func _ready() -> void:
    sprite.play("fly")
    controls_disabled = false
    $RemoteTransform2D.remote_path = camera.get_path()
    controls_on.emit(self)
    
    scene_root = get_tree()
    
func _input(event: InputEvent) -> void:
    ### Only triggers when bird press 'e'
    if event.is_action_pressed("egg_drop") and not controls_disabled:
        
        ### Audio for egg
        audio_player.stream = egg_sound
        audio_player.play()
        ###
        
        var spawned_egg = bird_egg.instantiate()
        var parent_node = scene_root.get_first_node_in_group("GameObjects")
        parent_node.add_child(spawned_egg)
        spawned_egg.global_position = self.global_position + Vector2(0, 20)

func _physics_process(delta: float) -> void:
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    if Input.is_action_just_pressed("switch_char"):
            controls_disabled = not controls_disabled
            $RemoteTransform2D.update_position = false
            if controls_disabled:
                velocity = Vector2.ZERO
            else:
                controls_on.emit(self)
    if not controls_disabled:
        var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
        direction = direction.normalized()

        _check_for_sprite_move(direction.x)

        #velocity = direction * SPEED
        velocity = lerp(velocity, direction * SPEED, FRICTION * delta)
        if Input.is_action_just_pressed("bird_peck"):
            peck_anim_play.play("PeckAnim") 
            
            ### Audio for egg
            audio_player.stream = peck_sound
            audio_player.play()
            ###
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


func _on_camera_2d_done_moving() -> void:
    if not controls_disabled:
        $RemoteTransform2D.update_position = true
    else:
        $RemoteTransform2D.update_position = false
