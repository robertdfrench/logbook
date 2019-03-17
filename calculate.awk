{ 
	print "T_BEGIN=$(date -j -f \"%Y-%m-%d %H:%M:%S\" \""$1,$2"\" \"+%s\")"
	print "T_END=$(date -j -f \"%Y-%m-%d %H:%M:%S\" \""$1,$3"\" \"+%s\")"
	print "T_TOTAL=$(echo \"scale=1; ($T_END - $T_BEGIN)/3600\" | bc)"
	print "echo '<tr><th scope=\"row\">"$1"</th><td>"$2"</td><td>"$3"</td><td>'$T_TOTAL'</td></th>'"
}
