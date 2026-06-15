extends StaticBody2D

@onready var pango_button: Node2D = $"../Wall1PangoButton"
@onready var bird_button: Node2D = $"../Wall1BirdButton"
@onready var wall_coll: CollisionShape2D = $CollisionShape2D
@onready var wall_sprite: NinePatchRect = $WallSprite

var task_complete : bool = false

func _process(delta: float) -> void:
	if task_complete == false:
		if pango_button.button_pressed == true and bird_button.button_pressed == true:
			wall_sprite.visible = false
			wall_coll.disabled = true
			task_complete = true
