extends CanvasLayer
signal start_game

var heart
var heart_full
var heart_empty

# Called when the node enters the scene tree for the first time.
func _ready():
	heart = get_tree().get_nodes_in_group("heart")
	heart_full = load("res://dodge_the_creeps_2d_assets/art/heart_full.png")
	heart_empty = load("res://dodge_the_creeps_2d_assets/art/heart_empty.png")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	

func show_game_over():
	show_message("Game Over")
	
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	await  get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score):
	$TimeLabel.text = "Time:" + str(score)
	
func update_killnum(kill_num):
	$KillLabel.text = "Kill:" + str(kill_num)
	

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()


func heart_changed_to(new_heart):
	for i in heart.size():
		if i < new_heart:
			heart[i].texture = heart_full
		else:
			heart[i].texture = heart_empty

		
	
	
	
