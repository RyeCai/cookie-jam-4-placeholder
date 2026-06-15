extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


var button_pressed : bool

func _ready() -> void:
	sprite.play("button_default")

func _on_button_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bird") or body.is_in_group("Egg"):
		sprite.play("button_pressed")
		button_pressed = true


func _on_button_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Bird") or body.is_in_group("Egg"):
		sprite.play("button_default")
		button_pressed = false
