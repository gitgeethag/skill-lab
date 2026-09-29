#Create a simulator object
set ns [new Simulator]
#Create a tracefile
set tracefile [prg1.te w]
$ns trace-all $tracefile

#Create a NAM file
set namfile [prg1.nam w]
$ns namtrace-all $namfile

#Create two nodes
set n0 [$ns node]
set n1 [$ns node]

#Create a duplex line between the two nodes
$ns duplex-link $n0 $n1 1Mb 10ms DropTail

#Create UDP agent at node 0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

#Create Null agent at node1
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0

#Connect UDP agent to Null agent
$ns connect $udp0 $null0

#Create CBR traffic
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 512
$cbr0 set interval_ 0.05
$cbr0 attach-agent $udp0

#Start and stop traffic
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

#Finish procedure
proc finish{} {
    global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile

exec nam prg1.nam &
exit 0
}
#End simulation
$ns at 5.0 "finish"
#Start simulation
$ns run