BEGIN{
    stime=0
    ftime=0
     flag=0
    fsize=0
    throughput=0
    latency=0
    rate=0
    packets=0

    stime1=0
    ftime1=0
     flag1=0
    fsize1=0
    throughput1=0
    latency1=0
    rate1=0
    packets1=0

    stime2=0
    ftime2=0
     flag2=0
    fsize2=0
    throughput2=0
    latency2=0
    rate2=0
    packets2=0

    stime3=0
    ftime3=0
     flag3=0
    fsize3=0
    throughput3=0
    latency3=0
    rate3=0
    packets3=0
}
{
    if ($1=="r" && $4==8 && $8==1){
        fsize+=$6
        if(flag==0){
            stime=$2
            flag=1
        }
        ftime=$2
    }

    if ($1=="r" && $4==8 && $8==2){
        fsize1+=$6
        if(flag1==0){
            stime1=$2
            flag1=1
        }
        ftime1=$2
    }

    if ($1=="r" && $4==9 ){
        fsize2+=$6
        if(flag2==0){
            stime2=$2
            flag2=1
        }
        ftime2=$2
    }


    if ($1=="r" && $4==2 ){
        fsize3+=$6
        if(flag3==0){
            stime3=$2
            flag3=1
        }
        ftime3=$2
    }
}

{
    if($1=="-" && $3==0)
    packets++

    if($1=="-" && $3==1)
    packets1++

    if($1=="-" && $3==2)
    packets2++

    if($1=="-" && $3==9)
    packets3++
}


END{
    latency = ftime - stime
    throughput = (fsize *8) / latency /1000
    rate = packets / latency
    printf("\n Latency of TCP Newreno: %f", latency)
    printf("\n Throughput of TCP Newreno: %f Kbps", throughput)
    printf("\n Mean Packets Rate of TCP Newreno: %f packets/sec\n", rate)

    latency1 = ftime1 - stime1
    throughput1 = (fsize1 *8) / latency1 /1000
    rate1 = packets1 / latency1
    printf("\n Latency of TCP: %f", latency1)
    printf("\n Throughput of TCP: %f Kbps", throughput1)
    printf("\n Mean Packets Rate of TCP: %f packets/sec\n", rate1)

    latency2 = ftime2 - stime2
    throughput2 = (fsize2 *8) / latency2 /1000
    rate2 = packets2 / latency2
    printf("\n Latency of UDP (green): %f", latency2)
    printf("\n Throughput  of UDP (green): %f Kbps", throughput2)
    printf("\n Mean Packets Rate of UDP (green): %f packets/sec\n", rate2)

    latency3 = ftime3 - stime3
    throughput3 = (fsize3 *8) / latency3 /1000
    rate3 = packets3 / latency3
    printf("\n Latency of UDP (black): %f", latency3)
    printf("\n Throughput  of UDP (black): %f Kbps", throughput3)
    printf("\n Mean Packets Rate of UDP (black): %f packets/sec\n", rate3)
}
