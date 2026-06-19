extends Area2D

var bee_obj := preload("res://Puzzle Mechanic Objects/Bees.tscn")
var root_node

var max_num_bees := 1
var current_bees = 0

func _ready() -> void:
    root_node = get_tree()

func _on_body_entered(body: Node2D) -> void:
    if (body.is_in_group("Pangolin") and body.visible or body.is_in_group("Bird")) and current_bees < max_num_bees:
        var spawned_bee = bee_obj.instantiate()
        var parent_node = root_node.get_first_node_in_group("GameObjects")
        parent_node.call_deferred("add_child", spawned_bee)             ### Not to sure why i need this but something wrong with phys
        spawned_bee.global_position = self.global_position
        
        current_bees += 1
        
        #Sends body information to the instantiate bees
        spawned_bee.beehive = self
        spawned_bee.target = body
