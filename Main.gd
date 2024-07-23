extends Node

@export var mob_scene: PackedScene
#@export var ammo_scene: PackedScene

var score
var kill_num
var heart
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func game_over():
	$Player.hide()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSouth.play()
	
func new_game():
	score = 0
	kill_num = 0
	heart = 3
	
	$Player.start($StartPosition.position)
	$Player/AnimatedSprite2D.flip_v = false
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.update_killnum(kill_num)
	$HUD.heart_changed_to(heart)
	$HUD.show_message("Get Ready")
	$Music.play()


func _on_mob_timer_timeout():
	$MobTimer.wait_time = 1 - 0.005 * score if score < 100 else 0.5
	
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	var mob_types = mob.get_node("AnimatedSprite2D").sprite_frames.get_animation_names()
	mob.get_node("AnimatedSprite2D").play(mob_types[randi()%mob_types.size()])
	
	match mob.get_node("AnimatedSprite2D").animation:
		"walk":		
			direction += randf_range(-PI / 4, PI / 4)
			mob.rotation = direction
			var velocity = Vector2(randf_range(100.0 + score * 2, 150.0 + score * 2), 0.0) if score < 100 else Vector2(randf_range(300, 350), 0.0)
			mob.linear_velocity = velocity.rotated(direction)
		"fly":
			direction += randf_range(-PI / 4, PI / 4)
			mob.rotation = direction
			var velocity = Vector2(randf_range(150.0 + score * 2, 200.0 + score * 2), 0.0) if score < 100 else Vector2(randf_range(350, 400), 0.0)
			mob.linear_velocity = velocity.rotated(direction)
		"swim":
			var swimmob_direction = Vector2($Player.position - mob.position) 
			mob.rotation = swimmob_direction.angle()
			var velocity = Vector2(randf_range(100.0 + score * 2, 150.0 + score * 2), 0.0) if score < 100 else Vector2(randf_range(300, 350), 0.0)
			mob.linear_velocity = velocity.rotated(swimmob_direction.angle())
	
	add_child(mob)
	

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
		
	
func _on_player_hit():
	heart -= 1
	$HUD.heart_changed_to(heart)
	if heart == 0:
		game_over()



func _on_child_entered_tree(node):
	if node.name == "Ammo":
		var ammo = $Ammo
		ammo.hit_enemy.connect(_on_ammo_hit_enemy)
		

func _on_ammo_hit_enemy():
		kill_num += 1
		$HUD.update_killnum(kill_num)
		
