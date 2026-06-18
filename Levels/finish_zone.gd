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


func _process(_delta: float) -> void:
    win_achieved = bird_in and pango_in
