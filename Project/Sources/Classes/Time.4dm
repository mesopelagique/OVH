

Class constructor($date : Date; $time : Time)
	This:C1470.date:=$date
	This:C1470.time:=$time
	If (This:C1470.date=Null:C1517)
		This:C1470.date:=Current date:C33()
		If (This:C1470.time=Null:C1517)
			This:C1470.time:=Current time:C178()
		End if 
	Else 
		If (This:C1470.time=Null:C1517)
			This:C1470.time:=0  // midnight
		End if 
	End if 
	
Function diffFromNow()->$diff : Integer
	$diff:=cs:C1710.Time.new().diff(This:C1470)
	
Function diff($from : cs:C1710.Time)->$diff : Integer
	
	$diff:=0  // TODO diff