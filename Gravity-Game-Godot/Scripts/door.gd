extends StaticBody2D


func _on_key_body_entered(body: Node2D) -> void:
	hide()
	queue_free()
