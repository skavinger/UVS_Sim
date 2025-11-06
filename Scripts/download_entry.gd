extends Control

const cardRepoBaseURL = "https://github.com/skavinger/UVS_Dataset/raw/refs/heads/main/"
const GreenCheck = "res://Assets/GreenCheck.png"
const YellowBang = "res://Assets/YellowBang.png"
const RedX = "res://Assets/Red_X.png.png"

var setID
var dataMissmatch = false
var imageMissmatch = false
var status = ""
var massDownload = false

var imagesRequest
var imagesSmallRequest
var setDataRequest
var versionRequest

var pendingRequests = []

func setName(setEntryName):
	$SetName.text = setEntryName
	
func setStatus(icon):
	if icon == "green":
		$Status.texture = load(GreenCheck)
		$Update_Download.disabled = true
		$Update_Download.text = "Up To Date"
	elif icon == "yellow":
		$Status.texture = load(YellowBang)
		$Update_Download.disabled = false
		$Update_Download.text = "Update"
	else:
		$Status.texture = load(RedX)
		$Update_Download.disabled = false
		$Update_Download.text = "Download"

func _on_update_download_pressed() -> void:
	#Download path
	if !dataMissmatch and !imageMissmatch:
		downloadSet()
	else:
		updateSet()

func downloadSet():
	$Update_Download.text = "Downloading..."
	$Update_Download.disabled = true
	var fs = DirAccess.open("user://SetData/")
	fs.make_dir_recursive("user://SetData/" + setID)
	
	imagesRequest = HTTPRequest.new()
	add_child(imagesRequest)
	imagesRequest.request_completed.connect(self._download_completed.bind(["images"]))
	imagesRequest.download_file = "user://SetData/" + setID + "/Images.zip"
	
	var error = imagesRequest.request(cardRepoBaseURL + setID + "/Images.zip")
	pendingRequests.push_back("images")
	if error != OK:
		push_error("Unable to get set list from repo")
		
	imagesSmallRequest = HTTPRequest.new()
	add_child(imagesSmallRequest)
	imagesSmallRequest.request_completed.connect(self._download_completed.bind(["imagesS"]))
	imagesSmallRequest.download_file = "user://SetData/" + setID + "/Images_small.zip"
	
	error = imagesSmallRequest.request(cardRepoBaseURL + setID + "/Images_small.zip")
	pendingRequests.push_back("imagesS")
	if error != OK:
		push_error("Unable to get set list from repo")
		
	setDataRequest = HTTPRequest.new()
	add_child(setDataRequest)
	setDataRequest.request_completed.connect(self._download_completed.bind(["setData"]))
	setDataRequest.download_file = "user://SetData/" + setID + "/setData.json"
	
	error = setDataRequest.request(cardRepoBaseURL + setID + "/setData.json")
	pendingRequests.push_back("setData")
	if error != OK:
		push_error("Unable to get set list from repo")
		
	versionRequest = HTTPRequest.new()
	add_child(versionRequest)
	versionRequest.request_completed.connect(self._download_completed.bind(["version"]))
	versionRequest.download_file = "user://SetData/" + setID + "/version.json"
	
	error = versionRequest.request(cardRepoBaseURL + setID + "/version.json")
	pendingRequests.push_back("version")
	if error != OK:
		push_error("Unable to get set list from repo")
	
func _download_completed(result, _response_code, _headers, _body, extra):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Download Failed")
	if extra[0] == "images":
		remove_child(imagesRequest)
		pendingRequests.erase("images")
		extractZip("user://SetData/" + setID + "/Images.zip", "user://SetData/" + setID + "/")
	elif extra[0] == "imagesS":
		remove_child(imagesSmallRequest)
		pendingRequests.erase("imagesS")
		extractZip("user://SetData/" + setID + "/Images_small.zip", "user://SetData/" + setID + "/")
	elif extra[0] == "setData":
		remove_child(setDataRequest)
		pendingRequests.erase("setData")
	elif extra[0] == "version":
		remove_child(versionRequest)
		pendingRequests.erase("version")
	
	if pendingRequests.size() == 0:
		setStatus("green")
		checkMassDownload()

func extractZip(zipPath, unzipPath):
	var zipReader = ZIPReader.new()
	zipReader.open(zipPath)
	
	var unzipDir = DirAccess.open(unzipPath)
	var files = zipReader.get_files()
	
	for filePath in files:
		if filePath.ends_with("/"):
			unzipDir.make_dir_recursive(filePath)
			continue
		
		unzipDir.make_dir_recursive(unzipDir.get_current_dir().path_join(filePath).get_base_dir())
		var file = FileAccess.open(unzipDir.get_current_dir().path_join(filePath), FileAccess.WRITE)
		var buffer = zipReader.read_file(filePath)
		file.store_buffer(buffer)
	zipReader.close()
	DirAccess.remove_absolute(zipPath)

func checkMassDownload():
	if massDownload:
		$"../../../..".downloadNext()
		massDownload = false

func queForDownload():
	$Update_Download.text = "Queued..."
	$Update_Download.disabled = true
	massDownload = true

func updateSet():
	pass
