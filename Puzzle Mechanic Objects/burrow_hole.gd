extends Area2D

@export var connected_burrow : Area2D
@onready var teleport_location: Node2D = $TeleportLocation
var inside_range : bool


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Pangolin"):
		inside_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Pangolin"):
		inside_range = false

func _input(event: InputEvent) -> void:
	if inside_range == true:
		if event is InputEventKey and event.keycode == KEY_E and event.is_pressed():
			var pango = get_tree().get_first_node_in_group("Pangolin")
			pango.global_position = connected_burrow.teleport_location.global_position
