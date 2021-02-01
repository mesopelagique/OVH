
Class constructor($applicationKey : Text; $applicationSecret : Text; $endpoint : Text; $consumerKey : Text)
	This:C1470.applicationKey:=$applicationKey
	This:C1470.applicationSecret:=$applicationSecret
	This:C1470.endpoint:=$endpoint
	This:C1470.consumerKey:=$consumerKey
	This:C1470.httpClient:=cs:C1710.HTTPClient.new()
	
	
Function get($path : Text; $content : Variant; $headers : Object; $is_authenticated : Boolean)->$response : Variant
	
	If (/*preg_match('/^\/[^\/]+\.json$/';$path)*/False:C215)
		// Schema description must be access without authentication
		$response:=This:C1470.rawCall(HTTP GET method:K71:1; $path; $content; False:C215; $headers)
	Else 
		$response:=This:C1470.rawCall(HTTP GET method:K71:1; $path; $content; $is_authenticated; $headers)
	End if 
	
Function post($path : Text; $content : Variant; $headers : Object; $is_authenticated : Boolean)->$response : Variant
	$response:=This:C1470.rawCall(HTTP POST method:K71:2; $path; $content; $is_authenticated; $headers)
	
Function put($path : Text; $content : Variant; $headers : Object; $is_authenticated : Boolean)->$response : Variant
	$response:=This:C1470.rawCall(HTTP PUT method:K71:6; $path; $content; $is_authenticated; $headers)
	
Function delete($path : Text; $content : Variant; $headers : Object; $is_authenticated : Boolean)->$response : Variant
	$response:=This:C1470.rawCall(HTTP DELETE method:K71:5; $path; $content; $is_authenticated; $headers)
	
Function rawCall($method : Integer; $content : Variant; $headers : Object; $is_authenticated : Boolean)->$response : Variant
	If ($is_authenticated)
		ASSERT:C1129(This:C1470.applicationKey#Null:C1517; "Application key parameter is empty")
		ASSERT:C1129(This:C1470.applicationSecret#Null:C1517; "Application secret parameter is empty")
	End if 
	
	$url:=This:C1470.endpoint+$path
	$request=cs:C1710.Request.new($method; $url)
	
	
	$body:=""; 
	
	Case of 
		: ($content#Null:C1517) & ($method=HTTP GET method:K71:1)
/*$query_string=$request.getUri().getQuery()
			
$query:=New object()
If (!empty($query_string)){
$queries=explode(' & ',$query_string); 
foreach($queries as$element){
$key_value_query=explode('=',$element, 2); 
$query[$key_value_query[0]]=$key_value_query[1]; 
}
}
			
$query=array_merge($query,(array)$content); 
			
// rewrite query args to properly dump true/false parameters
foreach($query as$key=>$value){
If ($value===False){
$query[$key]="false"; 
}elseif($value===True){
$query[$key]="true"; 
}
}
			
$query=\GuzzleHttp\Psr7\build_query($query); 
			
$url=$request.getUri().withQuery($query)
			
$request:=$request.withUri($url)
*/
			$body:=""
		: ($content#Null:C1517)
			$body:=JSON Stringify:C1217($content)
			$request.getBody().write($body)
		Else 
			$body:=""
	End case 
	
	If ($headers=Null:C1517)
		$headers:=New object:C1471()
	End if 
	$headers["Content-Type"]:="application/json; charset=utf-8"
	
	If ($is_authenticated)
		$headers["X-Ovh-Application"]=This:C1470.applicationKey
		
		If ($this->time_delta=Null:C1517)
			This:C1470.calculateTimeDelta()
		End if 
		$now:=cs:C1710.Time.new().timestamp()+This:C1470.time_delta
		$headers["X-Ovh-Timestamp"]:=$now
		
		If (This:C1470.consumer_key#Null:C1517)
			$toSign:=This:C1470.applicationSecret+"+"+This:C1470.consumer_key+"+"+methodString($method)+"+"+$url+"+"+$body+"+"+$now
			$signature:="$1$"+sha1($toSign)
			$headers["X-Ovh-Consumer"]:=This:C1470.consumer_key
			$headers["X-Ovh-Signature"]=$signature
		End if 
		
	End if 
	$request.headers:=$headers
	$response:=This:C1470.httpClient.send($request)
	
Function calculateTimeDelta()->$time_delta : Integer
	
	If (This:C1470.time_delta=Null:C1517)
		$response:=This:C1470.rawCall(HTTP GET method:K71:1; "/auth/time"; Null:C1517; False:C215)
		$serverTimestamp:=Int:C8(String:C10($response.getBody()))
		
		This:C1470.time_delta=$serverTimestamp-cs:C1710.Time.new().timestamp()
	End if 
	
	$time_delta:=This:C1470.time_delta