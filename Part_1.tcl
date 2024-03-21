#Apostolopoulou Ioanna
#AEM: 03121

#Create a simulator object
set ns [new Simulator]

#Define different colors for data flows
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green
$ns color 4 Yellow
#$ns color 5 Pink

#Tell the simulator to use dynamic routing
$ns rtproto DV
Agent/rtProto/Direct set preference_ 200

#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a tracefile
set tf [open out.tr w]
$ns trace-all $tf

set f0 [open out0.tr w]
set f1 [open out1.tr w]
set f2 [open out2.tr w]
set f3 [open out3.tr w]

set outfile0 [open  outfile0.tr w]
set outfile1 [open  outfile1.tr w]


#Create ten nodes
set s1 [$ns node]
set s2 [$ns node]
set s3 [$ns node]
set r1 [$ns node]
set r2 [$ns node]
set r3 [$ns node]
set r4 [$ns node]
set r5 [$ns node]
set d1 [$ns node]
set d2 [$ns node]


#Create links between the nodes
$ns duplex-link $s1 $r1 5Mb 5ms DropTail 
$ns duplex-link $s2 $r1 5Mb 5ms DropTail 
$ns duplex-link $s3 $r1 5Mb 5ms DropTail 
$ns duplex-link $r1 $r2 2Mb 10ms DropTail
$ns duplex-link $r1 $r3 1Mb 10ms DropTail 
$ns duplex-link $r2 $r4 2Mb 10ms DropTail
$ns duplex-link $r3 $r5 1Mb 10ms DropTail
$ns duplex-link $r4 $r5 2Mb 10ms DropTail
$ns duplex-link $r5 $d1 5Mb 5ms DropTail
$ns duplex-link $r5 $d2 5Mb 5ms DropTail


#Set the node positions
$ns duplex-link-op $s1 $r1 orient right-down 
$ns duplex-link-op $s2 $r1 orient right 
$ns duplex-link-op $s3 $r1 orient right-up 
$ns duplex-link-op $r1 $r2 orient right-up 
$ns duplex-link-op $r1 $r3 orient right
$ns duplex-link-op $r2 $r4 orient right
$ns duplex-link-op $r3 $r5 orient right
$ns duplex-link-op $r4 $r5 orient right-down
$ns duplex-link-op $r5 $d1 orient right-up
$ns duplex-link-op $r5 $d2 orient right-down 

#Set limit in queue between node R1 and node R2
$ns duplex-link-op $r1 $r2 set limit_ 15

#Set limit in queue between node R1 and node R3
$ns duplex-link-op $r1 $r3 set limit_ 10


#Define a 'finish' procedure
proc finish {} {
	
    global ns nf tf
    $ns flush-trace
	global f0 f1 f2 f3
	global outfile0 outfile1
	#Close the output files
	close $f0
	close $f1
	close $f2
	close $f3
	close $outfile0
	close $outfile1
	#Close the trace file
    close $nf
    close $tf
	#Call xgraph to display the results
	exec xgraph out0.tr out1.tr out2.tr out3.tr -geometry 800x400 &
	exec xgraph outfile0.tr outfile1.tr -geometry 800x400 &
	#Execute nam on the trace file
    exec nam out.nam &
        exit 0
}

#Create a UDP agent and attach it to node s3
set udp0 [new Agent/UDP]
$udp0 set class_ 3
$ns attach-agent $s3 $udp0

# Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
# $cbr0 set packetSize_ 500
# $cbr0 set interval_ 0.005
$cbr0 set rate_ 1Mb
$cbr0 attach-agent $udp0

#Create a Null agent (a traffic sink) and attach it to node n9
set null0 [new Agent/LossMonitor]
$ns attach-agent $d2 $null0

#Create a UDP agent and attach it to node n9
set udp1 [new Agent/UDP]
$udp1 set class_ 4
$ns attach-agent $d2 $udp1

# Create a CBR traffic source and attach it to udp0
set cbr1 [new Application/Traffic/CBR]
# $cbr1 set packetSize_ 500
# $cbr1 set interval_ 0.005
$cbr1 set rate_ 1Mb
$cbr1 attach-agent $udp1

#Create a Null agent (a traffic sink) and attach it to node n5
set null1 [new Agent/LossMonitor]
$ns attach-agent $s3 $null1

#Connect the traffic source with the traffic sink
$ns connect $udp0 $null0  
$ns connect $udp1 $null1

#Create a UDP agent and attach it to node s1
set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
$ns attach-agent $s1 $tcp0

# Create a CBR traffic source and attach it to udp0
set ftp0 [new Application/FTP]
# $ftp0 set packetSize_ 500
# $ftp0 set interval_ 0.009
$ftp0 attach-agent $tcp0

#Create a Null agent (a traffic sink) and attach it to node n3
set sink0 [new Agent/TCPSink]
$ns attach-agent $d1 $sink0

#Connect the traffic sources with the traffic sink
$ns connect $tcp0 $sink0  


#Create a UDP agent and attach it to node s2
set tcp1 [new Agent/TCP/Newreno]
$tcp1 set class_ 2
$ns attach-agent $s2 $tcp1

# Create a CBR traffic source and attach it to udp0
set ftp1 [new Application/FTP]
# $ftp0 set packetSize_ 500
# $ftp1 set interval_ 0.009
$ftp1 attach-agent $tcp1

#Create a Null agent (a traffic sink) and attach it to node n3
set sink1 [new Agent/TCPSink]
$ns attach-agent $d2 $sink1

#Connect the traffic sources with the traffic sink
$ns connect $tcp1 $sink1 

#Define a procedure which periodically records the throughput of the traffic sources
proc record {} {
    global tcp0 tcp1 sink0 sink1 null0 null1 f0 f1 f2 f3 outfile0 outfile1
	# Set Congestion Window
	set cwnd0 [$tcp0 set cwnd_]
	set cwnd1 [$tcp1 set cwnd_]
	#Get an instance of the simulator
	set ns [Simulator instance]
	#Set the time after which the procedure should be called again
        set time 0.5
	#How many bytes have been received by the traffic sinks?
        set bw0 [$sink0 set bytes_]
        set bw1 [$sink1 set bytes_]
	set bw2 [$null0 set bytes_]
        set bw3 [$null1 set bytes_]
	#Get the current time
        set now [$ns now]
	#Calculate the bandwidth (in MBit/s) and write it to the files
        puts $f0 "$now [expr $bw0/$time*8/1000000]"
        puts $f1 "$now [expr $bw1/$time*8/1000000]"
	puts $f2 "$now [expr $bw2/$time*8/1000000]"
        puts $f3 "$now [expr $bw3/$time*8/1000000]"
	#Reset the bytes_ values on the traffic sinks
        $sink0 set bytes_ 0
        $sink1 set bytes_ 0
		$null0 set bytes_ 0
		$null1 set bytes_ 0

	# the data is recorded in a file called congestion.xg (this can be plotted # using xgraph or gnuplot. this example uses xgraph to plot the cwnd_
    puts  $outfile0  "$now $cwnd0"
	puts  $outfile1  "$now $cwnd1"

	#Re-schedule the procedure
        $ns at [expr $now+$time] "record"
}

# #Schedule events for the FTP & CBR agents
$ns at 1.0 "record"
# $ns  at  1.0  "record $tcp0  $outfile0"
# $ns  at  1.0  "record $tcp1  $outfile1"
$ns at 2.0 "$ftp0 start"
$ns at 2.0 "$ftp1 start"
$ns at 2.0 "$cbr0 start"
$ns at 2.0 "$cbr1 start"
$ns rtmodel-at 12.0 down $r3 $r5
$ns rtmodel-at 20.0 up $r3 $r5
$ns at 25.0 "$ftp0 stop"
$ns at 25.0 "$ftp1 stop"
$ns at 25.0 "$cbr0 stop"
$ns at 25.0 "$cbr1 stop"


#Call the finish procedure after 5 seconds of simulation time
$ns at 30.0 "finish"

#Run the simulation
$ns run
