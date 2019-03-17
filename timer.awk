BEGIN {
	ptime = ""
	ftime = ""
}{
	date = $2
	time = $3

	if (pdate != date) {
		if (NR > 1) print pdate,ftime,ptime
		ftime = time
	}

	ptime = time
	pdate = date
}
END {
	if (NR > 1) print pdate,ftime,ptime
}
