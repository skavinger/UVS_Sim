Dataset repo: https://github.com/skavinger/UVS_Dataset

To setup your card data copy the files from the dataset repo to:
- Windows: %APPDATA%\UVS_Sim\SetData
- Mac: ~/Library/Application Support/UVS_Sim/SetData
- Linux: ~/.local/share/UVS_Sim/SetData
Then you will need to unzip all the card image folders(TODO make a script that automates this)

TO DO for Manual Sim
- Get game actions to populate in chat box, and anonymize unknow cards when that happens
- Code UI for playing abilities on cards so you can tell what your opponent is doing without having to go though chat
- Matchmaking server
- Clean up card database
- General bug fixes

Proposals for full sim design ideas
- Handling abilities
- - Each ability type with have a Node2D manager object (ResponseManager, EnhanceManager,.. ect)
  - Each card in the card database will have an array of objects representing the abilites on the card and each object will contain the ability type and a path to a Scene with the code for that ability
  - - Each ability scene will have 3 functions, check_playabe, pay_costs, and resolve_effect
  - When building the deck object at the start of the game, the ability Scenes will be populated as child Nodes of the abilitiy managers
  - The manager Nodes will have a get_playable_abilities function that when called will loop through it's child nodes calling their check playable functions and returning any that return true
