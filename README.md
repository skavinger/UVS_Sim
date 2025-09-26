TO DO for Manual Sim
1) Add start screen/lobby
2) Add Deck builder
3) Implement multiplayer/networking code/User manager(maybe use something like Google login to save having to make and track our own user profiles)
4) ~~Add zone search for searching deck/discard/removed~~
5) ~~Finish adding zone movement code(missing Stage and Momentum)~~
6) Add commiting cards
7) Add health tracker
8) Add Speed/Zone/Damage tracker with reset button (4M4 seems a decent reset value)
9) Fix update_pos code to compress space between cards if it starts exceeding the length of the zone, maybe add a zone search button for the zone when that happens
10) Add cycle button probally to discard
11) Populate card database (I have an old script to scrape UVS Ultra I can repurpose for this)
12) ~~Add card inspector that lists the cards info when the card is selected~~


Proposals for full sim design ideas
- Handling abilities
- - Each ability type with have a Node2D manager object (ResponseManager, EnhanceManager,.. ect)
  - Each card in the card database will have an array of objects representing the abilites on the card and each object will contain the ability type and a path to a Scene with the code for that ability
  - - Each ability scene will have 3 functions, check_playabe, pay_costs, and resolve_effect
  - When building the deck object at the start of the game, the ability Scenes will be populated as child Nodes of the abilitiy managers
  - The manager Nodes will have a get_playable_abilities function that when called will loop through it's child nodes calling their check playable functions and returning any that return true
