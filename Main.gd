extends Node2D

var pipe_scene = preload("res://Pipe.tscn")
var player_alive = true
var game_started = false
var score = 0

func kill_player():
	$PipeTimer.stop()
	$HUD.update_text(str(score) + "\nPress Space To Reset  ")
	
	player_alive = false
	$Player.is_alive = false
	$Player.velocity = Vector2.DOWN * 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$PipeTimer.timeout.connect(_On_Pipe_Timer_Timeout)
	score = 0
	player_alive = true
	
func _On_Pipe_Timer_Timeout():
	var pipe = pipe_scene.instantiate()
	pipe.position += Vector2(350 + randi_range(-25, 25), randi_range(-150, 150))
	pipe.get_node("PipeArea2D").body_entered.connect(func(_body): kill_player())
	
	var score_func = func(_body): if player_alive: score += 1; $HUD.update_text(score); pipe.get_node("AudioStreamPlayer").play()
	pipe.get_node("MiddleArea2D").body_entered.connect(score_func)
	self.add_child(pipe)
	self.move_child(pipe, $Player.get_index())
	
func _process(_delta):
	if !game_started and Input.is_action_just_pressed("game_jump"):
		game_started = true
		$Player.is_active = true
		$PipeTimer.start()
		$HUD.update_text(score)
		
	if !player_alive and Input.is_action_just_pressed("game_jump"):
		get_tree().reload_current_scene()
	
func _on_area_2d_body_entered(_body):
	kill_player()
