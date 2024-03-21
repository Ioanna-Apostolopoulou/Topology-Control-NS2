BEGIN {
    FS = " ";
    startTime = 0;
    endTime = 0;
    flag[$8] = 0;
}

{
    event = $1;
    time = $2;
    flowID = $8;
    packetSize = $6;
    destinationNode = $4;
    sourceNode = $3;


    if (event == "r" && !(flowID == 0) && destinationNode == 9) {
        totalBytes[flowID] += packetSize;
        
        if(flag[flowID] == 0){
            startTime = time;
            flag[flowID] = 1;
        }
        endTime = time;
        
    }
    else if (event == "r" && !(flowID == 0) && destinationNode == 8) {
        totalBytes[flowID] += packetSize;
        if(flag[flowID] == 0){
            startTime = time;
            flag[flowID] = 1;
        }
        endTime = time;
    }
    else if (event == "r" && !(flowID == 0) && destinationNode == 3){
        totalBytes[flowID] += packetSize;
        if(flag[flowID] == 0){
            startTime = time;
            flag[flowID] = 1;
        }
        endTime = time;
    }

    if(event == "+"){
        totalPackets[flowID]++;
    }
}

END {
    totalDuration = endTime - startTime;
    
    for (flowID in totalPackets) {
        throughput = (totalBytes[flowID] * 8) / (totalDuration * 1000);  # in kbps
        print "Flow ID", flowID, ": ", throughput, " kbps";
        averagePacketRate = totalPackets[flowID] / totalDuration;
        print "Average Transfer Packet Rate to Sources: ", averagePacketRate, "packets/sec";
    }
}
    