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



class IntervalTimer
	constructor: (@ioPortBase, @irq) ->

		@RW_STATE_LSB = 1
		@RW_STATE_MSB = 2
		@RW_STATE_WORD = 3
		@RW_STATE_WORD_2 = 4
		@MODE_INTERRUPT_ON_TERMINAL_COUNT = 0
		@MODE_HARDWARE_RETRIGGABLE_ONE_SHOT = 1
		@MODE_RATE_GENERATOR = 2
		@MODE_SQUARE_WAVE = 3
		@MODE_SOFTWARE_TRIGGERED_STROBE = 4
		@MODE_HARDWARE_TRIGGERED_STROBE = 5

		@PIT_FREQ = 1193182

		@channels = []

	ioPortsRequested: ->
		return [@ioPortBase, @ioPortBase+1, @ioPortBase+2, @ioPortBase+3]



	initialised: ->
		if not @irqDevice
			return false
		if not @timeSource
			return false

		if not @ioPortRegistered
			return false
		return true

	acceptComponent: (component) ->
		if component instanceof InterruptController and component.initialised()
			@irqDevice = component

		if component instanceof clock and component.initialised()
			@timeSource = true

		if component instanceof IOPortHandler and component.initialised()
			component.registerIOPortCapable(@)
			@ioPortRegistered = true

#		if PCSpeaker && component instanceof PCSpeaker
#			@speaker = component

		if @initialised() and @channels.length == 0

			for i in [0...3]
				@channels[i] = new TimerChannel(i, @irqDevice)

			@channels[0].setIRQTimer(Clock.newTimer(@channels[0]))
			@channels[0].setIRQ(@irq)


	toString: ->
		"Intel i8254 Interval Timer"
