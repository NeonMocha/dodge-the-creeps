extends Node

@export var mob_scene: PackedScene

var score: int

@onready var score_timer: Timer = $ScoreTimer
@onready var mob_timer: Timer = $MobTimer
@onready var start_timer: Timer = $StartTimer
@onready var player: Player = $Player
@onready var hud: HUD = $HUD
@onready var start_position: Marker2D = $StartPosition
@onready var mob_spawn_location = $MobPath/MobSpawnLocation
@onready var music: AudioStreamPlayer2D = $Music
@onready var death_sound: AudioStreamPlayer2D = $DeathSound


func _on_player_hit() -> void:
	game_over()


func _on_mob_timer_timeout() -> void:
	var mob: Mob = mob_scene.instantiate()
	
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	hud.update_score(score)


func _on_start_timer_timeout() -> void:
	mob_timer.start()
	score_timer.start()


func _on_hud_start_game():
	new_game()
	
	
func game_over():
	score_timer.stop()
	mob_timer.stop()
	hud.show_game_over()
	music.stop()
	death_sound.play()


func new_game():
	score = 0
	player.start(start_position.position)
	start_timer.start()
	hud.update_score(score)
	hud.show_message("Get Ready!")
	get_tree().call_group("mobs", "queue_free")
	music.play()
