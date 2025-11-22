extends Control

var filter = {
	"cardName": null,
	"cardText": null,
	"format": "",
	"sets": [],
	"cardType": [],
	"symbols": [],
	"symbolsAttned": [],
	"keywordTraits": [],
	"keywordAbilities": [],
	"keywordCount": false,
	"keywordCountMode": "=",
	"keywordCountValue": null,
	"abilityCount": false,
	"abilityCountMode": "=",
	"abilityCountValue": null,
	"blockZone": null,
	"blockMod": false,
	"blockModMode": "=",
	"blockModValue": "",
	"speed": false,
	"speedMode": "=",
	"speedValue": 0,
	"attackZone": null,
	"damage": false,
	"damageMode": "=",
	"damageValue": 0,
	"handSize": false,
	"handSizeMode": "=",
	"handSizeValue": 0,
	"health": false,
	"healthMode": "=",
	"healthValue": 0,
	"difficulty": false,
	"difficultyMode": "=",
	"difficultyValue": 0,
	"check": false,
	"checkMode": "=",
	"checkValue": 0
}

func _ready() -> void:
	var formats = CardDatabase.getFormats()
	for i in range(formats.size()):
		$Menus/Formats.get_popup().add_item(formats[i])
	$Menus/Formats.get_popup().id_pressed.connect(_format_selected)
	
	var sets = CardDatabase.getSets()
	for i in range(sets.size()):
		$Menus/Sets.get_popup().add_check_item(sets[i])
	$Menus/Sets.get_popup().hide_on_checkable_item_selection = false
	$Menus/Sets.get_popup().id_pressed.connect(_sets_selected)
	
	$Menus/Symbols.get_popup().hide_on_checkable_item_selection = false
	$Menus/Symbols.get_popup().id_pressed.connect(_symbols_selected)
	
	$Menus/SymbolsAttuned.get_popup().hide_on_checkable_item_selection = false
	$Menus/SymbolsAttuned.get_popup().id_pressed.connect(_attuned_selected)
	
	var traits = CardDatabase.getKeywordTraits()
	for i in range(traits.size()):
		$Menus/KeywordTraits.get_popup().add_check_item(traits[i])
		
	$Menus/KeywordTraits.get_popup().hide_on_checkable_item_selection = false
	$Menus/KeywordTraits.get_popup().id_pressed.connect(_kTraits_selected)
	
	var abilities = CardDatabase.getKeywordAbilities()
	for i in range(abilities.size()):
		$Menus/KeywordAbilities.get_popup().add_check_item(abilities[i].Name)
		
	$Menus/KeywordAbilities.get_popup().hide_on_checkable_item_selection = false
	$Menus/KeywordAbilities.get_popup().id_pressed.connect(_kAbilities_selected)
	
	$"Menus/Difficulty/Diff><=".get_popup().id_pressed.connect(_diffMode_selected)
	$"Menus/Check/Check><=".get_popup().id_pressed.connect(_checkMode_selected)
	
	$Menus/BlockZone.get_popup().id_pressed.connect(_blockZone_selected)
	$Menus/CardType.get_popup().id_pressed.connect(_cardType_selected)
	$Menus/CardType.get_popup().hide_on_checkable_item_selection = false
	
	$"Menus/KeywordCount/KeywordCount><=".get_popup().id_pressed.connect(_keywordCountMode_selected)
	$"Menus/AbilityCount/AbilityCount><=".get_popup().id_pressed.connect(_abilityCountMode_selected)
	
	$"Menus/BlockMod/BlockMod><=".get_popup().id_pressed.connect(_blockModMode_selected)
	
	$"Menus/Speed/Speed><=".get_popup().id_pressed.connect(_speedMode_selected)
	$Menus/AttackZone.get_popup().id_pressed.connect(_attackZone_selected)
	$"Menus/Damage/Damage><=".get_popup().id_pressed.connect(_damageMode_selected)
	
	$"Menus/HandSize/HandSize><=".get_popup().id_pressed.connect(_handSizeMode_selected)
	$"Menus/Health/Health><=".get_popup().id_pressed.connect(_healthMode_selected)

func _format_selected(id):
	var formatName = $Menus/Formats.get_popup().get_item_text(id)
	filter.sets = []
	if formatName != "None":
		filter.format = formatName
		$Menus/Formats.text = formatName
		var formatList = CardDatabase.getFormat(formatName)
		$Menus/Sets.get_popup().clear()
		for i in range(formatList.size()):
			$Menus/Sets.get_popup().add_check_item(formatList[i])
	else:
		filter.format = ""
		$Menus/Formats.text = "Format"
		var formatList = CardDatabase.getFormat("Legacy")
		$Menus/Sets.get_popup().clear()
		for i in range(formatList.size()):
			$Menus/Sets.get_popup().add_check_item(formatList[i])
	
func _sets_selected(id):
	var setName = $Menus/Sets.get_popup().get_item_text(id)
	if $Menus/Sets.get_popup().is_item_checked(id):
		$Menus/Sets.get_popup().set_item_checked(id, false)
		for i in range(filter.sets.size()):
			if filter.sets[i] == setName:
				filter.sets.remove_at(i)
				break
	else:
		$Menus/Sets.get_popup().set_item_checked(id, true)
		filter.sets.append(setName)

func _symbols_selected(id):
	var symbol = $Menus/Symbols.get_popup().get_item_text(id)
	if $Menus/Symbols.get_popup().is_item_checked(id):
		$Menus/Symbols.get_popup().set_item_checked(id, false)
		for i in range(filter.symbols.size()):
			if filter.symbols[i] == symbol:
				filter.symbols.remove_at(i)
				break
	else:
		$Menus/Symbols.get_popup().set_item_checked(id, true)
		filter.symbols.append(symbol)
		
func _attuned_selected(id):
	var attunedSymbol = $Menus/SymbolsAttuned.get_popup().get_item_text(id)
	if $Menus/SymbolsAttuned.get_popup().is_item_checked(id):
		$Menus/SymbolsAttuned.get_popup().set_item_checked(id, false)
		for i in range(filter.symbolsAttned.size()):
			if filter.symbolsAttned[i] == attunedSymbol:
				filter.symbolsAttned.remove_at(i)
				break
	else:
		$Menus/SymbolsAttuned.get_popup().set_item_checked(id, true)
		filter.symbolsAttned.append(attunedSymbol)
		
func _kTraits_selected(id):
	var kTrait = $Menus/KeywordTraits.get_popup().get_item_text(id)
	if $Menus/KeywordTraits.get_popup().is_item_checked(id):
		$Menus/KeywordTraits.get_popup().set_item_checked(id, false)
		for i in range(filter.keywordTraits.size()):
			if filter.keywordTraits[i] == kTrait:
				filter.keywordTraits.remove_at(i)
				break
	else:
		$Menus/KeywordTraits.get_popup().set_item_checked(id, true)
		filter.keywordTraits.append(kTrait)
		
func _kAbilities_selected(id):
	var kAbility = $Menus/KeywordAbilities.get_popup().get_item_text(id)
	if $Menus/KeywordAbilities.get_popup().is_item_checked(id):
		$Menus/KeywordAbilities.get_popup().set_item_checked(id, false)
		for i in range(filter.keywordAbilities.size()):
			if filter.keywordAbilities[i] == kAbility:
				filter.keywordAbilities.remove_at(i)
				break
	else:
		$Menus/KeywordAbilities.get_popup().set_item_checked(id, true)
		filter.keywordAbilities.append(kAbility)


func _on_check_label_pressed() -> void:
	if $Menus/Check/CheckLabel.button_pressed:
		filter.check = true
	else:
		filter.check = false

func _checkMode_selected(id):
	var mode = $"Menus/Check/Check><=".get_popup().get_item_text(id)
	filter.checkMode = mode
	$"Menus/Check/Check><=".text = mode

func _on_check_value_text_changed(new_text: String) -> void:
	filter.checkValue = int(new_text)

func _on_diff_label_pressed() -> void:
	if $Menus/Difficulty/DiffLabel.button_pressed:
		filter.difficulty = true
	else:
		filter.difficulty = false

func _diffMode_selected(id):
	var mode = $"Menus/Difficulty/Diff><=".get_popup().get_item_text(id)
	filter.difficultyMode = mode
	$"Menus/Difficulty/Diff><=".text = mode

func _on_diff_value_text_changed(new_text: String) -> void:
	filter.difficultyValue = int(new_text)
	

func _blockZone_selected(id):
	var zone = $Menus/BlockZone.get_popup().get_item_text(id)
	if zone != "Disabled":
		filter.blockZone = zone
		$Menus/BlockZone.text = "Block Zone: " + zone
	else:
		filter.blockZone = null
		$Menus/BlockZone.text = "Block Zone"

func _on_card_name_text_changed(new_text: String) -> void:
	if new_text == "":
		filter.cardName = null
	else:
		filter.cardName = new_text

func _on_card_text_text_changed(new_text: String) -> void:
	if new_text == "":
		filter.cardText = null
	else:
		filter.cardText = new_text

func _cardType_selected(id):
	var cardType = $Menus/CardType.get_popup().get_item_text(id)
	if $Menus/CardType.get_popup().is_item_checked(id):
		$Menus/CardType.get_popup().set_item_checked(id, false)
		for i in range(filter.cardType.size()):
			if filter.cardType[i] == cardType:
				filter.cardType.remove_at(i)
				break
	else:
		$Menus/CardType.get_popup().set_item_checked(id, true)
		filter.cardType.append(cardType)

func _on_keyword_count_label_pressed() -> void:
	if $Menus/KeywordCount/KeywordCountLabel.button_pressed:
		filter.keywordCount = true
	else:
		filter.keywordCount = false

func _keywordCountMode_selected(id):
	var mode = $"Menus/KeywordCount/KeywordCount><=".get_popup().get_item_text(id)
	filter.keywordCountMode = mode
	$"Menus/KeywordCount/KeywordCount><=".text = mode

func _on_keyword_count_value_text_changed(new_text: String) -> void:
	if new_text == "":
		filter.keywordCountValue = null
	else:
		filter.keywordCountValue = int(new_text)

func _on_ability_count_label_pressed() -> void:
	if $Menus/AbilityCount/AbilityCountLabel.button_pressed:
		filter.abilityCount = true
	else:
		filter.abilityCount = false

func _abilityCountMode_selected(id):
	var mode = $"Menus/AbilityCount/AbilityCount><=".get_popup().get_item_text(id)
	filter.abilityCountMode = mode
	$"Menus/AbilityCount/AbilityCount><=".text = mode

func _on_ability_count_value_text_changed(new_text: String) -> void:
	if new_text == "":
		filter.abilityCountValue = null
	else:
		filter.abilityCountValue = int(new_text)

func _on_block_mod_label_pressed() -> void:
	if $Menus/BlockMod/BlockModLabel.button_pressed:
		filter.blockMod = true
	else:
		filter.blockMod = false

func _blockModMode_selected(id):
	var mode = $"Menus/BlockMod/BlockMod><=".get_popup().get_item_text(id)
	filter.blockModMode = mode
	$"Menus/BlockMod/BlockMod><=".text = mode

func _on_block_mod_value_text_changed(new_text: String) -> void:
	if new_text == "":
		filter.blockModValue = null
	else:
		filter.blockModValue = int(new_text)

func _on_speed_label_pressed() -> void:
	if $Menus/Speed/SpeedLabel.button_pressed:
		filter.speed = true
	else:
		filter.speed = false

func _speedMode_selected(id):
	var mode = $"Menus/Speed/Speed><=".get_popup().get_item_text(id)
	filter.speedMode = mode
	$"Menus/Speed/Speed><=".text = mode

func _on_speed_value_text_changed(new_text: String) -> void:
	if new_text == "":
		filter.speedValue = null
	else:
		filter.speedValue = int(new_text)

func _attackZone_selected(id):
	var zone = $Menus/AttackZone.get_popup().get_item_text(id)
	if zone != "Disabled":
		filter.attackZone = zone
		$Menus/AttackZone.text = "Attack Zone: " + zone
	else:
		filter.attackZone = null
		$Menus/AttackZone.text = "Attack Zone"

func _on_damage_label_pressed() -> void:
	if $Menus/Damage/DamageLabel.button_pressed:
		filter.damage = true
	else:
		filter.damage = false

func _damageMode_selected(id):
	var mode = $"Menus/Damage/Damage><=".get_popup().get_item_text(id)
	filter.damageMode = mode
	$"Menus/Damage/Damage><=".text = mode

func _on_damage_value_text_changed(new_text: String) -> void:
	if new_text == "":
		filter.damageValue = null
	else:
		filter.damageValue = int(new_text)

func _on_hand_size_label_pressed() -> void:
	if $Menus/HandSize/HandSizeLabel.button_pressed:
		filter.handSize = true
	else:
		filter.handSize = false

func _handSizeMode_selected(id):
	var mode = $"Menus/HandSize/HandSize><=".get_popup().get_item_text(id)
	filter.handSizeMode = mode
	$"Menus/HandSize/HandSize><=".text = mode

func _on_hand_size_value_text_changed(new_text: String) -> void:
	if new_text == "":
		filter.handSizeValue = null
	else:
		filter.handSizeValue = int(new_text)
		
func _on_health_label_pressed() -> void:
	if $Menus/Health/HealthLabel.button_pressed:
		filter.health = true
	else:
		filter.health = false

func _healthMode_selected(id):
	var mode = $"Menus/Health/Health><=".get_popup().get_item_text(id)
	filter.healthMode = mode
	$"Menus/Health/Health><=".text = mode

func _on_health_value_text_changed(new_text: String) -> void:
	if new_text == "":
		filter.healthValue = null
	else:
		filter.healthValue = int(new_text)
