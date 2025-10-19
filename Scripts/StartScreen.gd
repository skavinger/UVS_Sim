extends Node2D

var currentDeckList = {
		"character": {
			"cardID" : {
				"set" : "cha03gmm",
				"number" : "001"
			}
		}, 
		"main": [
			{
				"count" : 4,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "013"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "014"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "015"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "016"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "017"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "018"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "019"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "020"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "021"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "022"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "006"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "007"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "008"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "009"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "010"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "011"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "012"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "004"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "cha03gmm",
					"number" : "005"
				}
			}
		],
		"side": []
	}

func _ready() -> void:
	$StartWindowHolder.spawnWindow()
