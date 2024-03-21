BEGIN {
    FS = " ";
    srand();  # Seed the random number generator
}

/^r/ {
    eventType = $1;
    time = $2;
    sourceNode = $3;
    destinationNode = $4;
    packetType = $5;
    packetSize = $6;
    flags = $7;
    flowID = $8;
    sequenceNumber = $9;
    eventID = $10;

    if (sourceNode != destinationNode && !(flowID in flowTimes)) {
        flowTimes[flowID] = time;
    }
    if (sourceNode != destinationNode && eventID < flowSequence[flowID]) {
        flowTimes[flowID] = time - flowTimes[flowID];
        flowSequence[flowID] = eventID;
    }
}

END {
    print "Time taken for a packet from each different flow to arrive at destination:";
    for (flow in flowTimes) {
        print "Flow", flow, ":", flowTimes[flow], "seconds";
    }
}