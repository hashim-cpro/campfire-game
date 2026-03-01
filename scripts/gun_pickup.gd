extends Area2D

signal _if_body_entered(body) 

func _on_body_entered(body: Node2D) -> void:
	print("Player enetered gun area, removing gun...")
	emit_signal("_if_body_entered", body) # Emit the signal when the player enters
	queue_free() 
