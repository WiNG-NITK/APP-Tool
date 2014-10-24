BEGIN {
seqno = -1; 
droppedPackets = 0;
receivedPackets = 0;
count = 0;
}
{
# Trace line format: normal
	if ($2 != "-t") {
		event = $1
		time = $2
		if (event == "+" || event == "-") node_id = $3
		if (event == "r" || event == "d") node_id = $4
		flow_id = $8
		pkt_id = $12
		pkt_size = $6
		flow_t = $5
		seqno=$11
		level = "AGT"
	}
	# Trace line format: new
	if ($2 == "-t") {
		event = $1
		time = $3
		node_id = $5
		flow_id = $39
		pkt_id = $41
		pkt_size = $37
		flow_t = $45
		level = $19
		seqno = $11
	}
#packet delivery ratio
if(level == "AGT" && event == "s" && seqno < $11) {
seqno = $11;
}
else if((level == "AGT") && (event == "r")) {
 receivedPackets++;
}
 else if ((event == "d") && (flow_id > 512) && (level == "AGT")){
droppedPackets++; 
}
}
  
END{ 
 print "GeneratedPackets = " seqno+1;
 print "ReceivedPackets = " receivedPackets;
print "Packet Delivery Ratio = " receivedPackets/(seqno+1)*100
 "%";
print "Total Dropped Packets = " droppedPackets;
 }
