class_name HUD
extends CanvasLayer

signal start_game

@onready var score_label: Label = $ScoreLabel
@onready var message: Label = $Message
@onready var message_timer: Timer = $MessageTimer
@onready var start_button: Button = $StartButton


func _on_start_button_pressed() -> void:
	start_button.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	message.hide()


func update_score(score):
	score_label.text = str(score)


func show_message(text):
	message.text = text
	message.show()
	message_timer.start()


func show_game_over():
	show_message("Game Over")
	await message_timer.timeout
	
	message.text = "Dodge the Creeps!"
	message.show()
	
	await get_tree().create_timer(1.0).timeout
	start_button.show()
