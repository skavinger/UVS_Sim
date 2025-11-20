extends Node2D

func displayMessage(message):
	$".".position = Vector2(960,400)
	$RichTextLabel.text = message
	
func hideMessage():
	$".".position = Vector2(960,-400)

func hideButtons():
	$Yes.visible = false
	$Yes.disabled = true
	$No.visible = false
	$No.disabled = true
	
func showButtons():
	$Yes.visible = true
	$Yes.disabled = false
	$No.visible = true
	$No.disabled = false

func _on_yes_pressed() -> void:
	$"../../SyncFunctions".rpc_id(1, "sendRivalMessageReply", "yes")

func _on_no_pressed() -> void:
	$"../../SyncFunctions".rpc_id(1, "sendRivalMessageReply", "no")
