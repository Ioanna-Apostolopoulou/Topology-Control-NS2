BEGIN {
    FS = " ";
}

{
    eventType = $1;
    flowID = $8;

    if(eventType == "d"){
        packets[flowID]++;
    }
}

END{
    for (flowID in packets){
        print("Flow ID :" flowID " Packets Dropped : " packets[flowID]);
    }
}