extends Node2D

signal hit_enemy
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot(start_position, velocity):
	position = start_position
	$RigidBody2D.linear_velocity = Vector2(0.0, -800.0) if velocity.length() == 0.0 else velocity * 2


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_rigid_body_2d_body_entered(body):
	hit_enemy.emit()
	queue_free()
	body.queue_free()
