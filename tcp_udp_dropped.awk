BEGIN {
    FS = " ";
    dropped_tcp_green = 0;
    dropped_tcp_blue = 0;
    dropped_udp_green = 0;
    dropped_udp_blue = 0;
    total = 0;
    
}

/^d/{
    packetType = $5;
    sourceNode = $3;
    destinationNode = $4;

    if (packetType == "tcp" && sourceNode == 3 && destinationNode == 4) 
    {
        dropped_tcp_green++;
        total++;
        
    }
    else if (packetType == "tcp" && sourceNode == 3 && destinationNode == 5)
    {
        dropped_tcp_blue++;
        total++;

    }
    else if (packetType == "cbr"  && sourceNode == 3 && destinationNode == 4) 
    {
        dropped_udp_green++;
        total++;

    }
        
    else if (packetType == "cbr"  && sourceNode == 3 && destinationNode == 5) 
    {
        dropped_udp_blue++;
        total++;
   
    }
    
}

END {
    tcp_green = (dropped_tcp_green/total) * 100;
    print "Percentage of TCP Packets Dropped in Green Flow is %d", tcp_green;

    tcp_blue = (dropped_tcp_blue/total) * 100;
    print "Percentage of TCP Packets Dropped in Blue Flow is %d", tcp_blue;

    udp_green = (dropped_udp_green/total) * 100;
    print "Percentage of UDP Packets Dropped in Green Flow is %d", udp_green;

    udp_blue = (dropped_udp_blue/total) * 100;
    print "Percentage of UDP Packets Dropped in Blue Flow is %d", udp_blue;
    
    print "Total is " , total;
}