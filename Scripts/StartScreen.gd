extends Node2D

var currentDeckList = {
		"character": {
			"cardID" : {
				"set" : "CHA03-GMM",
				"number" : "01"
			}
		}, 
		"main": [
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "13"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "14"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "15"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "16"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "17"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "18"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "19"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "20"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "21"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "22"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "06"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "07"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "08"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "09"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "10"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "11"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "12"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "04"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "05"
				}
			}
		],
		"side": []
	}

func _ready() -> void:
	$StartWindowHolder.spawnWindow()
