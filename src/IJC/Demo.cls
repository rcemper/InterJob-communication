/// simple demo of InterJob Communication 
Class IJC.Demo  {
 
Parameter Listener = 224;

/// the monitor to receive and display messages
ClassMethod %Start() As %Status
{
   set ijc=..#Listener
   open ijc::0
   set msg="IJC Listener "_ijc_$s($t:"",1:"already")_" active"
   write msg,!
   else  set sc=$system.Status.Error(77,msg) quit sc
#;   set stop=0
   for  {
       use ijc read pushmsg use 0 write pushmsg,!
       if $e(pushmsg,1,4)="STOP" quit
    }
    quit $$$OK
}
 
/// simulation of a random writing sensor
ClassMethod Sensor(txt As %String = {$J}) as %Status
{
   set ijc=..#Listener+1
   for  {
    open ijc::0
    if '$T  {
        use 0 write "Monitor "_(ijc-1)_" busy",!
        hang 0.3
        continue
        }
    set hng1=$r(100)+1/10_"sec"
        ,msg=txt_" "_$zdt($now(),3,,3)_" hang "_hng1
    use ijc write msg
    close ijc    ;release connection
    if $e(msg,1,4)="STOP" quit
    hang hng1
    }
   quit $$$OK
}
 
ClassMethod STOP() as %String
{   quit ..Sensor("STOP") }
}
