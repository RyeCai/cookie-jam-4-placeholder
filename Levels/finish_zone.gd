extends Area2D

var pango_in : bool
var bird_in : bool

var win_achieved : bool


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Pangolin"):
		pango_in = true
	if body.is_in_group("Bird"):
		bird_in = true
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Pangolin"):
		pango_in = false
	if body.is_in_group("Bird"):
		bird_in = false


func _process(delta: float) -> void:
	if pango_in == true and bird_in == true:
		win_achieved == true
