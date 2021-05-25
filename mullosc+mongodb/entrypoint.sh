#!/bin/bash
ERR=0
if ! [[ -e /ranfirst ]] ; then
    re="^[A-z0-9]{14,18}$"
	if [[ $MAXMINKEY =~ $re ]] ; then
		if ! [ -e /usr/share/GeoIP/GeoLite2-City.mmdb ]
		then
			echo "Installing GeoLite2-City database.." > /proc/1/fd/1
			wget -qO GeoLite2-City.tar.gz "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAXMINKEY&suffix=tar.gz"
			mkdir geo
			tar -zxf GeoLite2-City.tar.gz -C geo --strip 1
			mv /geo/GeoLite2-City.mmdb /usr/share/GeoIP/
			rm -r geo
			rm GeoLite2-City.tar.gz
		fi
	else
	    echo "Missing MAXMINKEY environment variable." > /proc/1/fd/1
	    ERR=1
	fi
	re="^[A-z0-9]{38,42}$"
	if [[ $GOOGLEKEY =~ $re ]] ; then
		sed -i "s/mapskey/$GOOGLEKEY/" /mollusc/mollusc.conf
	else
	    echo "Missing GOOGLEKEY environment variable." > /proc/1/fd/1
	    ERR=1
	fi
	re="^[A-z0-9]{14,18}$"
	if [[ $SHODANKEY =~ $re ]] ; then
		sed -i "s,\\(^enabled \=\\) .*,\\1 True," /mollusc/mollusc.conf
		sed -i "s/shodankey/$SHODANKEY/" /mollusc/mollusc.conf
	fi
	touch ranfirst
fi	
if [[ $ERR == 1 ]] ; then
	echo "Please correct above errors. Program exited." > /proc/1/fd/1
else
	echo "Starting services.." > /proc/1/fd/1
	/usr/bin/supervisord
fi
