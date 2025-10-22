extends Control

var filter = {
	"format": "",
	"sets": [],
	"symbols": [],
	"symbolsAttned": [],
	"keywordTraits": [],
	"keywordAbilities": [],
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
	
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Air.png"), "Air")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/All.png"), "All")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Chaos.png"), "Chaos")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Death.png"), "Death")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Earth.png"), "Earth")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Evil.png"), "Evil")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Fire.png"), "Fire")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Good.png"), "Good")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Life.png"), "Life")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Order.png"), "Order")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Void.png"), "Void")
	$Menus/Symbols.get_popup().add_icon_check_item(load("res://Assets/Symbols/Water.png"), "Water")
	
	$Menus/Symbols.get_popup().hide_on_checkable_item_selection = false
	$Menus/Symbols.get_popup().id_pressed.connect(_symbols_selected)
	
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Air-Attune.png"), "Air")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/All-Attune.png"), "All")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Chaos-Attune.png"), "Chaos")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Death-Attune.png"), "Death")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Earth-Attune.png"), "Earth")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Evil-Attune.png"), "Evil")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Fire-Attune.png"), "Fire")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Good-Attune.png"), "Good")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Life-Attune.png"), "Life")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Order-Attune.png"), "Order")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Void-Attune.png"), "Void")
	$Menus/SymbolsAttuned.get_popup().add_icon_check_item(load("res://Assets/Attuned/Water-Attune.png"), "Water")
	
	$Menus/SymbolsAttuned.get_popup().hide_on_checkable_item_selection = false
	$Menus/SymbolsAttuned.get_popup().id_pressed.connect(_attuned_selected)
	
	var traits = CardDatabase.getKeywordTraits()
	for i in range(traits.size()):
		$Menus/KeywordTraits.get_popup().add_check_item(traits[i])
		
	$Menus/KeywordTraits.get_popup().hide_on_checkable_item_selection = false
	$Menus/KeywordTraits.get_popup().id_pressed.connect(_kTraits_selected)
	
	var abilities = CardDatabase.getKeywordAbilities()
	for i in range(abilities.size()):
		$Menus/KeywordAbilities.get_popup().add_check_item(abilities[i])
		
	$Menus/KeywordAbilities.get_popup().hide_on_checkable_item_selection = false
	$Menus/KeywordAbilities.get_popup().id_pressed.connect(_kAbilities_selected)
	
	$"Menus/Diff><=".get_popup().id_pressed.connect(_diffMode_selected)
	$"Menus/Check><=".get_popup().id_pressed.connect(_checkMode_selected)
	
func _format_selected(id):
	var formatName = $Menus/Formats.get_popup().get_item_text(id)
	filter.format = formatName
	$Menus/Formats.text = formatName
	var formatList = CardDatabase.getFormat(formatName)
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
	if $Menus/CheckLabel.toggle_mode:
		filter.check = false
	else:
		filter.check = true

func _checkMode_selected(id):
	var mode = $"Menus/Check><=".get_popup().get_item_text(id)
	filter.checkMode = mode
	$"Menus/Check><=".text = mode

func _on_check_value_text_changed(new_text: String) -> void:
	filter.checkValue = int(new_text)

func _on_diff_label_pressed() -> void:
	if $Menus/DiffLabel.toggle_mode:
		filter.difficulty = false
	else:
		filter.difficulty = true

func _diffMode_selected(id):
	var mode = $"Menus/Diff><=".get_popup().get_item_text(id)
	filter.difficultyMode = mode
	$"Menus/Diff><=".text = mode

func _on_diff_value_text_changed(new_text: String) -> void:
	filter.difficultyValue = int(new_text)
	
