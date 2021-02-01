//%attributes = {}
#DECLARE ($method : Integer)->$string : Text

Case of 
	: ($method=HTTP GET method:K71:1)
		$string:="GET"
	: ($method=HTTP POST method:K71:2)
		$string:="POST"
	: ($method=HTTP DELETE method:K71:5)
		$string:="DELETE"
	: ($method=HTTP PUT method:K71:6)
		$string:="PUT"
	Else 
		
End case 