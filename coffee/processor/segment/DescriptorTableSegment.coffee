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

class DescriptorTableSegment extends Segment
	constructor: (@base, limit) ->
		super
		@limit = 0xffffffff & limit;

	checkAddress: (offset) ->
		if (0xffffffff & offset) > @limit
			log "Offset beyond end of Descriptor Table Segment: Offset=" + offset + ", limit=" + @limit
			throw new ProcessorException(Type.GENERAL_PROTECTION, offset, true)
	translateAddressRead: (offset) ->
		@checkAddress(offset)
		return @base + offset
