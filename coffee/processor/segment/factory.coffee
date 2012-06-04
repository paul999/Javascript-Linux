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

class SegmentFactory
	constructor: ->
		@DESCRIPTOR_TYPE = 0x100000000000
		@SEGMENT_TYPE = 0xf0000000000
		@NULL_SEGMENT = new NullSegment()

	createRealModeSegment: (selector) ->
		return new RealModeSegment(selector)

	createDescriptorTableSegment: (base, limit) ->
		return new DescriptorTableSegment(base, limit)

	createProtectedModeSegment: (selector, descriptor) ->

		tmp = ((descriptor & (@DESCRIPTOR_TYPE | @SEGMENT_TYPE)) >>> 40)

		log "TMP: #{tmp}"

		switch tmp
			when 0x01
				return new Available16BitTSS(selector, descriptor)
			when 0x02
				return new LDT(selector, descriptor)
			when 0x03
				return new Busy16BitTSS(selector, descriptor)
			when 0x04
				return new CallGate16Bit(memory, selector, descriptor)
			when 0x05
				return new TaskGate(memory, selector, descriptor)
			when 0x06
				return new InterruptGate16Bit(memory, selector, descriptor)
			when 0x07
				return new TrapGate16Bit(memory, selector, descriptor)
			when 0x09
				return new Available32BitTSS(memory, selector, descriptor)
			when 0x0b
				return new Busy32BitTSS(memory, selector, descriptor)
			when 0x0c
				return new CallGate32Bit(memory, selector, descriptor)
			when 0x0e
				return new InterruptGate32Bit(memory, selector, descriptor)
			when 0x0f
				return new TrapGate32Bit(memory, selector, descriptor)


			when 0x10
				return new ReadOnlyDataSegment(memory, selector, descriptor)
			when 0x11
				return new ReadOnlyAccessedDataSegment(memory, selector, descriptor)
			when 0x12
				return new ReadWriteDataSegment(memory, selector, descriptor)
			when 0x13
				return new ReadWriteAccessedDataSegment(memory, selector, descriptor)
			when 0x14
				throw new IllegalStateException("Unimplemented Data Segment: Read-Only, Expand-Down")
			when 0x15
				throw new IllegalStateException("Unimplemented Data Segment: Read-Only, Expand-Down, Accessed")
			when 0x16
				return new ProtectedModeExpandDownSegment.ReadWriteDataSegment(memory, selector, descriptor)
			when 0x17
				throw new IllegalStateException("Unimplemented Data Segment: Read/Write, Expand-Down, Accessed")

			when 0x18
				return new ExecuteOnlyCodeSegment(memory, selector, descriptor)
			when 0x19
				throw new IllegalStateException("Unimplemented Code Segment: Execute-Only, Accessed")
			when 0x1a
				return new ExecuteReadCodeSegment(memory, selector, descriptor)
			when 0x1b
				return new ExecuteReadAccessedCodeSegment(memory, selector, descriptor)
			when 0x1c
				throw new IllegalStateException("Unimplemented Code Segment: Execute-Only, Conforming")
			when 0x1d
				return new ExecuteOnlyConformingAccessedCodeSegment(memory, selector, descriptor)
			when 0x1e
				return new ExecuteReadConformingCodeSegment(memory, selector, descriptor)
			when 0x1f
				return new ExecuteReadConformingAccessedCodeSegment(memory, selector, descriptor)

			else
				throw new ProcessorException(Type.GENERAL_PROTECTION, 0, true)
