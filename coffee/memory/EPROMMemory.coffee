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

class EPROMMemory extends LazyCodeBlockMemory
	constructor: (@size, manager) ->
		log "Create EPROMMemory"
		super(size, manager)

	load: (base, data, offset, length) ->
		@copyArrayIntoContents(base, data, offset, length)

	load2: (data, offset, length) ->
		@load(0, data, offset, length)

	toString: () ->
		"EPROMMemory"

	getSize: ->
		return 4096

#	setByte: ->
#		return
	initialised: ->
		return true

	writeAttempted: (address, size) ->
		log "Write of #{size} bytes attempted at address #{address}"
