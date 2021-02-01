// https:  //github.com/ovh/php-ovh-sms/blob/master/src/SmsApi.php
Class constructor($applicationKey : Text; $applicationSecret : Text; $endpoint : Text; $consumerKey : Text)
	This:C1470.connection:=cs:C1710.Api.new($applicationKey; $applicationSecret; $endpoint; $consumerKey)
	
Function getAccounts(/*$details: Boolean*/)->$accounts : Collection
	$accounts:=New collection:C1472()
	$accounts:=This:C1470.conn.get("/sms/")
	
Function getSenders()->$senders : Collection
	$senders:=New collection:C1472()
	
Function setAccount($account : cs:C1710.Account)
	This:C1470.account:=$account
	
Function createMessage($bool : Boolean)->$message : cs:C1710.Message
	$message:=cs:C1710.Message.new(This:C1470)
	$message.addReceiver()
	
Function getPlannedMessages()->$messages : Object
	$messages:=New collection:C1472()
	If (Asserted:C1132(This:C1470.account#Null:C1517; "Please set account before using this function"))
		
		// Get messages
		$messages:=This:C1470.conn.get(This:C1470.getUri()+"jobs")
		
		For each ($id; $messages)
			$messages[$id]=cs:C1710.Sms.new(This:C1470; "jobs"; $message[$id])
		End for each 
		
	End if 
	
Function getUri()->$uri : Text
	$uri:="/sms/"+This:C1470.account+"/"
	$user:=This:C1470.getUser()
	If ($user#Null:C1517)
		$uri:=$uri+"users/"+$user+"/"
	End if 
	
Function getConnection()
	$0:=This:C1470.connection
	
Function getAccount()
	ASSERT:C1129(This:C1470.account#Null:C1517; "Please set account before using this function")
	$0:=This:C1470.account
	
Function getAccountDetails($account : Text)
	$0:=This:C1470.conn.get("/sms/"+$account)
	