extends Node

func checkPlayable(gameNode):
	if gameNode.get_node("Field").get_node("TurnSequence").currentPhase == "CombatPhaseEnhance":
		return true
	else:
		return false

func payCosts(_gameNode):
	pass

func resolveEffect(gameNode):
	var romanCancelToken = {
		"cardID": {"set": "ggs01", "number": "000"},
		"indexID": -2,
		"cardProperties": CardDatabase.getCard({"set": "ggs01", "number": "000"}),
		"cardState": gameNode.get_node("Player").get_node("Deck").defaultCardState.duplicate(),
		"cardObj": null
	}
	romanCancelToken.cardState.currentZone = "token"
	gameNode.get_node("Player").get_node("Transit").move_to("momentum", romanCancelToken, true)
