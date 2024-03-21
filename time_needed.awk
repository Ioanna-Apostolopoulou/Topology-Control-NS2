BEGIN{
    stime1=0
    stime2=0
    stime3=0
    stime4=0
    ftime1=0
    ftime2=0
    ftime3=0
    ftime4=0
    flag1=0
    flag2=0
    flag3=0
    flag4=0
    packetid=0
    packetid1=0
    packetid2=0
    packetid3=0
    time=0
    time1=0
    time2=0
    time3=0
}

{
    if ($1=="+" && $8==1 && flag1==0 && $6>40){
        packetid = $12
        stime1 = $2
        flag1 = 1
        }

    if ($1=="r" && $12==packetid){
        ftime1 = $2
    }
}

{
    if ($1=="+" && $8==2 && flag2==0 && $6>40){
        packetid1 = $12
        stime2 = $2
        flag2 = 1
        }

    if ($1=="r" && $12==packetid1){
        ftime2 = $2
    }
}
{
    if ($1=="+" && $8==3 && flag3==0){
        packetid2 = $12
        stime3 = $2
        flag3 = 1
        }

    if ($1=="r" && $12==packetid2){
        ftime3 = $2
    }
}
{
    if ($1=="+" && $8==0 && flag4==0 && $12>500){
        packetid3 = $12
        stime4 = $2
        flag4 = 1
        }

    if ($1=="r" && $12==packetid3){
        ftime4 = $2
    }
}

END{
    time = ftime1 - stime1
    time1 = ftime2 - stime2
    time2 = ftime3 - stime3
    time3 = ftime4 - stime4
    printf("\n The time needed for a packet of TCP-Newreno is: %f", time)
    printf("\n The time needed for a packet of TCP is: %f", time1)
    printf("\n The time needed for a packet of UDP of s3 is: %f", time2)
    printf("\n The time needed for a packet of UDP of d2 is: %f\n", time3)
}
