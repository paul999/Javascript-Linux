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

class RealModeSegment extends Segment
	constructor: (@memory, @selector) ->
		super(@memory)
		log "create realmodesegment"

		@base = @selector << 4
		@limit = 0xffff
		@rpl = 0
		@type = @TYPE_DATA_WRITABLE | @TYPE_ACCESSED

		log @base

	translateAddressRead: (offset) ->
		return @base + offset
