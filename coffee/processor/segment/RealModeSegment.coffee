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
	constructor: (@selector) ->
		super()

		@base = @selector << 4
		@limit = 0xffff
		@rpl = 0
		@type = @TYPE_DATA_WRITABLE | @TYPE_ACCESSED
		@defaultSize = false
#		@defaultSize = true

	translateAddressRead: (offset) ->
		return @base + offset
		return offset

	getDefaultSizeFlag: ->
		return @defaultSize

	translateAddressWrite: (offset) ->
		return @base + offset
		return offset

	checkAddress: (offset) ->
		return
		if (offset) > @limit
			log "Segment limit exceeded: offset=#{offset}, limit: #{@limit}"
			throw new ProcessorException(type.GENERAL_PROTECTION, 0, true)
	getSelector: ->
		return @selector

	setSelector: (selector) ->
		@selector = selector
		@base = selector << 4
		@type = 0x01 | 0x02
