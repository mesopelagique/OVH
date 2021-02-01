

Function send($request : cs:C1710.Request)->$response : Variant
	
	ARRAY TEXT:C222($headersNames; 0)
	ARRAY TEXT:C222($headersValues; 0)
	
	If (Value type:C1509($request.headers)=Is object:K8:27)
		ARRAY TEXT:C222($headersNames; $request.headers.length)
		ARRAY TEXT:C222($headersValues; $request.headers.length)
		$i:=1
		For each ($headerName; $request.headers)
			$headersNames{$i}:=$headerName
			$headersValues{$i}:=String:C10($request.headers[$headerName])
			$i:=$i+1
		End for each 
	Else 
		ARRAY TEXT:C222($headersNames; 0)
		ARRAY TEXT:C222($headersValues; 0)
	End if 
	
	$code:=HTTP Request:C1158($request.method; $request.uri; $request.body; $responseBody; $headersNames; $headersValues)
	
	$headers:=New object:C1471()
	// TODO fill from $headersNames
	
	$response:=cs:C1710.Response.new()
	$response.code:=$code
	$response.headers:=$headers
	$response.body:=$responseBody
	$response.request:=$request