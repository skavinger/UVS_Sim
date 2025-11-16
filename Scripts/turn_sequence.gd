extends Node2D



var playerOne
var playersTurn

var currentPhase

func setFirst(firstBool):
	playerOne = firstBool
	playersTurn = firstBool
	rpc_id(1, "recieveFirst", !firstBool)
	updateTurnPlayer()
	currentPhase = "StartOfGame"
	
@rpc("any_peer")
func recieveFirst(firstBool):
	playerOne = firstBool
	playersTurn = firstBool
	updateTurnPlayer()
	currentPhase = "StartOfGame"

func updateTurnPlayer():
	if playersTurn:
		$TurnPlayer.texture = preload("res://Assets/TurnSequence/YourTurn.png")
	else:
		$TurnPlayer.texture = preload("res://Assets/TurnSequence/RivalsTurn.png")

func advancePhase():
	if playersTurn:
		match currentPhase:
			"StartOfGame":
				currentPhase = "Mulligains"
				$"../../Player/Deck".drawToHandSize()
				$TurnSequence.texture = preload("res://Assets/TurnSequence/Mulligans.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"Mulligains":
				currentPhase = "CombatPhaseOpen"
				$"../../Player/Deck".drawToHandSize()
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"StartPhaseReady":
				currentPhase = "StartPhaseReview"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReviewGreen.png")
				toggleAttackSeqButtons(false)
				$"../../Player/Stage".readyStage()
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"StartPhaseReview":
				currentPhase = "StartPhaseDraw"
				$"../../Player/Deck".drawToHandSize()
				$TurnSequence.texture = preload("res://Assets/TurnSequence/DrawGreen.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"StartPhaseDraw":
				currentPhase = "CombatPhaseOpen"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
				toggleAttackSeqButtons(true)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"CombatPhaseOpen":
				currentPhase = "EndPhase"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/EndGreen.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"CombatPhaseEnhance":
				currentPhase = "CombatPhaseBlock"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/BlockGreen.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"CombatPhaseBlock":
				currentPhase = "CombatPhaseDamage"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/DamageGreen.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"CombatPhaseDamage":
				currentPhase = "CombatPhaseOpen"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
				toggleAttackSeqButtons(true)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"EndPhase":
				currentPhase = "StartPhaseReady"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReadyRed.png")
				toggleAttackSeqButtons(false)
				playersTurn = false
				rpc_id(1, "swapPlayerTurn", currentPhase)
				updateTurnPlayer()

func revertPhase():
	if playersTurn:
		match currentPhase:
			"StartPhaseReady":
				currentPhase = "EndPhase"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/EndRed.png")
				toggleAttackSeqButtons(false)
				playersTurn = false
				rpc_id(1, "swapPlayerTurn", currentPhase)
				updateTurnPlayer()
			"StartPhaseReview":
				currentPhase = "StartPhaseReady"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReadyGreen.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"StartPhaseDraw":
				currentPhase = "StartPhaseReview"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReviewGreen.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"CombatPhaseOpen":
				currentPhase = "StartPhaseDraw"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/DrawGreen.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"CombatPhaseEnhance":
				currentPhase = "CombatPhaseOpen"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
				toggleAttackSeqButtons(true)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"CombatPhaseBlock":
				currentPhase = "CombatPhaseEnhance"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/EnhanceGreen.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"CombatPhaseDamage":
				currentPhase = "CombatPhaseBlock"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/BlockGreen.png")
				toggleAttackSeqButtons(false)
				rpc_id(1, "updateRivalsPhase",currentPhase)
			"EndPhase":
				currentPhase = "CombatPhaseOpen"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
				toggleAttackSeqButtons(true)
				rpc_id(1, "updateRivalsPhase",currentPhase)
		
			
@rpc("any_peer")
func updateRivalsPhase(newPhase):
	if(currentPhase == "Mulligains"):
		$"../../Player/Deck".drawToHandSize()
	currentPhase = newPhase
	if playersTurn:
		match currentPhase:
			"Mulligains":
				$"../../Player/Deck".drawToHandSize()
				$TurnSequence.texture = preload("res://Assets/TurnSequence/Mulligans.png")
			"StartPhaseReady":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReadyGreen.png")
			"StartPhaseReview":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReviewGreen.png")
			"StartPhaseDraw":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/DrawGreen.png")
			"CombatPhaseOpen":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
			"CombatPhaseEnhance":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/EnhanceGreen.png")
			"CombatPhaseBlock":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/BlockGreen.png")
			"CombatPhaseDamage":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/DamageGreen.png")
			"EndPhase":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/EndGreen.png")
	else:
		match currentPhase:
			"Mulligains":
				$"../../Player/Deck".drawToHandSize()
				$TurnSequence.texture = preload("res://Assets/TurnSequence/Mulligans.png")
			"StartPhaseReady":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReadyRed.png")
			"StartPhaseReview":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReviewRed.png")
			"StartPhaseDraw":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/DrawRed.png")
			"CombatPhaseOpen":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenRed.png")
			"CombatPhaseEnhance":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/EnhanceRed.png")
			"CombatPhaseBlock":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/BlockRed.png")
			"CombatPhaseDamage":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/DamageRed.png")
			"EndPhase":
				$TurnSequence.texture = preload("res://Assets/TurnSequence/EndRed.png")

func enterAttackSequence():
	if playersTurn:
		currentPhase = "CombatPhaseEnhance"
		$TurnSequence.texture = preload("res://Assets/TurnSequence/EnhanceGreen.png")

@rpc("any_peer")
func swapPlayerTurn(toPhase):
	playersTurn = true
	updateTurnPlayer()
	currentPhase = toPhase
	match currentPhase:
		"StartPhaseReady":
			$TurnSequence.texture = preload("res://Assets/TurnSequence/ReadyGreen.png")
		"EndPhase":
			$TurnSequence.texture = preload("res://Assets/TurnSequence/EndGreen.png")

func toggleAttackSeqButtons(buttonsOn):
	if buttonsOn:
		$"../AttackSeq".visible = true
		$"../AttackSeq/Area2D/CollisionShape2D".disabled = false
	else:
		$"../AttackSeq".visible = false
		$"../AttackSeq/Area2D/CollisionShape2D".disabled = true

func startAttackSeq():
	currentPhase = "CombatPhaseEnhance"
	$TurnSequence.texture = preload("res://Assets/TurnSequence/EnhanceGreen.png")
	toggleAttackSeqButtons(false)
	rpc_id(1, "updateRivalsPhase",currentPhase)
