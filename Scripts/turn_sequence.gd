extends Node2D



var playerOne
var playersTurn

var currentPhase

func setFirst(firstBool):
	playerOne = firstBool
	playersTurn = firstBool
	rpc("recieveFirst", !firstBool)
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
				rpc("updateRivalsPhase",currentPhase)
			"Mulligains":
				currentPhase = "CombatPhaseOpen"
				$"../../Player/Deck".drawToHandSize()
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"StartPhaseReady":
				currentPhase = "StartPhaseReview"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReviewGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"StartPhaseReview":
				currentPhase = "StartPhaseDraw"
				$"../../Player/Deck".drawToHandSize()
				$TurnSequence.texture = preload("res://Assets/TurnSequence/DrawGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"StartPhaseDraw":
				currentPhase = "CombatPhaseOpen"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"CombatPhaseOpen":
				currentPhase = "EndPhase"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/EndGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"CombatPhaseEnhance":
				currentPhase = "CombatPhaseBlock"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/BlockGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"CombatPhaseBlock":
				currentPhase = "CombatPhaseDamage"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/DamageGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"CombatPhaseDamage":
				currentPhase = "CombatPhaseOpen"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"EndPhase":
				currentPhase = "StartPhaseReady"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReadyRed.png")
				playersTurn = false
				rpc("swapPlayerTurn", currentPhase)
				updateTurnPlayer()

func revertPhase():
	if playersTurn:
		match currentPhase:
			"StartPhaseReady":
				currentPhase = "EndPhase"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/EndRed.png")
				playersTurn = false
				rpc("swapPlayerTurn", currentPhase)
				updateTurnPlayer()
			"StartPhaseReview":
				currentPhase = "StartPhaseReady"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReadyGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"StartPhaseDraw":
				currentPhase = "StartPhaseReview"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/ReviewGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"CombatPhaseOpen":
				currentPhase = "StartPhaseDraw"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/DrawGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"CombatPhaseEnhance":
				currentPhase = "CombatPhaseOpen"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"CombatPhaseBlock":
				currentPhase = "CombatPhaseEnhance"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/EnhanceGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"CombatPhaseDamage":
				currentPhase = "CombatPhaseBlock"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/BlockGreen.png")
				rpc("updateRivalsPhase",currentPhase)
			"EndPhase":
				currentPhase = "CombatPhaseOpen"
				$TurnSequence.texture = preload("res://Assets/TurnSequence/OpenGreen.png")
				rpc("updateRivalsPhase",currentPhase)
		
			
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
