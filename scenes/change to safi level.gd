extends Area2D

# Exporting the path makes it easy to change the level in the Inspector

func _on_body_entered(body: CharacterBody2D) -> void:
	
		get_tree().change_scene_to_file("res://scenes/safi_scene-2.tscn")
