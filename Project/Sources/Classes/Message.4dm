
Class constructor($sms : cs:C1710.SmsApi)
	This:C1470.sms:=$sms
	ASSERT:C1129(This:C1470.sms#Null:C1517; "Cannot construct message without Sms api")
	This:C1470.receivers:=New collection:C1472()
	
Function addReceiver($receiver : Text)->$this : cs:C1710.Message
	
	// TODO Asserted match regex /^(\+|00)[1-9][0-9]{9,16}$/
	// TODO maybe replace starting 00 by +
	
	This:C1470.receivers.push($receiver)
	$this:=This:C1470
	
Function setIsMarketing($marketing : Boolean)->$this : cs:C1710.Message
	This:C1470.isMarketing:=$marketing
	$this:=This:C1470
	
Function setDeliveryDate($date : Date; $time : Time)->$this : cs:C1710.Message
	This:C1470.deliveryDate:=cs:C1710.Time.new($date; $time)
	ASSERT:C1129(This:C1470.deliveryDate.diffFromNow()>0; "Delivery date parameter can't be in the past")
	$this:=This:C1470
	
Function setSender($sender : cs:C1710.Sender)->$this : cs:C1710.Message
	This:C1470.sender:=$sender
	$this:=This:C1470
	
Function send($message : Text)->$result : Collection
	
	$differedPeriod:=0
	If (This:C1470.deliveryDate#Null:C1517)
		$differedPeriod:=This:C1470.deliveryDate.diffFromNow()
	End if 
	
	If (Asserted:C1132($differedPeriod>=0; "Delivery date parameter can't be in the past"))
		
		// Manage coding
		$coding:=Choose:C955(This:C1470.isGSM0338($message); "7bit"; "8bit")
		
		// Prepare request parameters
		$parameters:=New object:C1471("message"; $message; \
			"receivers"; This:C1470.receivers; \
			"noStopClause"; Bool:C1537(This:C1470.isMarketing); \
			"differedPeriod"; $differedPeriod; \
			"coding"; $coding; \
			"tag"; This:C1470.tag)
		
		If (This:C1470.sender#Null:C1517)
			$parameters.sender:=This:C1470.sender
		Else 
			$parameters.senderForResponse:=True:C214
		End if 
		
		$result:=This:C1470.sms.getConnection().post(This:C1470.sms.getUri()+"jobs"; $parameters)
		
	End if 
	
Function isGSM0338($msg : Text)->$gsm0338 : Boolean
	$gsm0338:=False:C215
	
	