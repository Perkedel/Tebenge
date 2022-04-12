extends HTTPRequest


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var selectedPurposeId:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func requestWithPurpose(purposeId:int=0,url: String="", custom_headers: PoolStringArray = [], ssl_validate_domain: bool = true, method: int = HTTPClient.Method.METHOD_GET, request_data: String = "")->void:
	selectedPurposeId = purposeId
	request(url,custom_headers,ssl_validate_domain,method,request_data)
	pass

signal request_doned(purpose,result,response_code,headers,body)
func _on_TebengeHTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	emit_signal("request_doned",selectedPurposeId,result,response_code,headers,body)
	pass # Replace with function body.
