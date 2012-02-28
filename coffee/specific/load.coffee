# A JavaScript x86 emulator
# Some of the code based on:
#	JPC: A x86 PC Hardware Emulator for a pure Java Virtual Machine
#	Release Version 2.0
#
#	A project from the Physics Dept, The University of Oxford
#
#	Copyright (C) 2007-2009 Isis Innovation Limited
#
# Javascript version written by Paul Sohier, 2012
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as published by
# the Free Software Foundation.

loadFile = (location, address, callback, save) ->
	log "Load file #{location}"

	xmlhttp = null

	if (window.XMLHttpRequest)
		xmlhttp = new XMLHttpRequest()
	else
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		log "Your browser is unsuported!"

	xmlhttp.onreadystatechange = () ->
		if (xmlhttp.readyState == 4)

			if(xmlhttp.status == 200 || xmlhttp.status == 0) # Chrome gives 0 back when ok

				if (save(xmlhttp.response, xmlhttp.response.length, address))
					callback (true)
				else
					callback(false)
			else
				log "Got a not standard (#{xmlhttp.status}) back, aborting..."
				callback(false)
				return


	xmlhttp.open("GET",location,true);
	xmlhttp.overrideMimeType('text/plain; charset=x-user-defined')
	xmlhttp.send();
