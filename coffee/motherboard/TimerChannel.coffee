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
# This program is free software you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as published by
# the Free Software Foundation.

class Interval
	constructor: ->


class TimerChannel extends TimerResponsive
	constructor: (index, @irqDevice) ->

		if not @irqDevice
			throw IllegalStateException('IRQ device is required')

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

		@mode = @MODE_SQUARE_WAVE
		@gate = (index != 2)
		@loadCount(0)
		@nullCount

	read: ->
		if @statusLatched
			@statusLatched = false
			return @status

		switch @countLatched
			when @RW_STATE_LSB
				@countLatched = 0
				return @outputLatch & 0xff
			when @RW_STATE_MSB
				@countLatched = 0
				return (@outputLatch >>> 8) & 0xff
			when @RW_STATE_WORD
				@countLatched = @RW_STATE_WORD_2
				return @outputLatch & 0xff
			when @RW_STATE_WORD_2
				@countLatched = 0
				return (@outputLatch >>> 8) & 0xff
			else
				switch @readState
					when @RW_STATE_LSB
						return @getCount() & 0xff
					when @RW_STATE_MSB
						return (@getCount() >>> 8) & 0xff
					when @RW_STATE_WORD
						@readState = @RW_STATE_WORD_2
						return @getCount() & 0xff
					when @RW_STATE_WORD_2
						@readState = @RW_STATE_WORD
						return (@getCount() >>> 8) & 0xff
	readBack: (data) ->
		if (data & 0x20) == 0
			@latchCount()

		if (data & 0x10) == 0
			@latchStatus()

	latchCount: ->
		if @countLatched == 0
			@outputLatch = @getCount()
			@countLatched = @rwMode

	latchStatus: ->
		if @statusLatched
			@status = (@getOut(Clock.getTime()) << 7) | (nullCount ? 0x40 : 0x00) | (@rwMode << 4) | (@mode << 1) | @bcd
			@statusLatched = true

	write: (data) ->
		switch @writeState
			when @RW_STATE_LSB
				@nullCount = true
				@loadCount(0xff & data)

			when @RW_STATE_MSB
				@nullCount = true
				@loadCount((0xff & data) << 8)

			when @RW_STATE_WORD
				@inputLatch = @data
				@writeState = @RW_STATE_WORD_2

			when @RW_STATE_WORD_2
				@nullCount = true
				@loadCount((0xff & @inputLatch) | ((0xff & data) << 8))

				@writeState = @RW_STATE_WORD

			else
				@nullCount = true
				@loadCount(0xff & data)

	writeControlWord: (data) ->
		accesss = (data >>> 4) & 3

		if access == 0
			@latchCount()
		else
			@nullCount = true

			@rwMode = access
			@readState = access
			@writeState = access

			@mode = (data >>> 1) & 7
			@bcd = data & 1

	setGate: (value) ->
		switch mode
			when @MODE_INTERRUPT_ON_TERMINAL_COUNT, @MODE_SOFTWARE_TRIGGERED_STROBE
				break
			when @MODE_HARDWARE_RETRIGGERABLE_ONE_SHOT, @MODE_HARDWARE_TRIGGERED_STROBE
				if not @gate && value
					@countStartTime = Clock.getTime()

					@irqTimerUpdate(@countStartTime)
			when @MODE_RATE_GENERATOR, @MODE_SQUARE_WAVE
				if not @gate && value
					@countStartTime = Clock.getTime()

					@irqTimerUpdate(@countStartTime)
			else
				break
		@gate = value

	getCount: ->
		now = scale64(Clock.getTime() - @countStartTime, @PIT_FREQ, int(Clock.getTickRate()))

		switch @mode
			when @MODE_INTERRUPT_ON_TERMINAL_COUNT, @MODE_HARDWARE_RETRIGGERABLE_ONE_SHOT, @MODE_SOFTWARE_TRIGGERED_STROBE, @MODE_HARDWARE_TRIGGERED_STROBE
				return int(((@countValue - now) & 0xffff))
			when @MODE_SQUARE_WAVE
				return int((@countValue - ((2 * now) % @countValue)))

			else
				return int(@countValue - (now % @countValue))

	getOut: (currentTime) ->
		now = scale64(currentTime - @countStartTime, @PIT_FREQ, Clock.getTickRate())

		switch @mode
			when @MODE_INTERRUPT_ON_TERMINAL_COUNT
				if now >= @countValue
					return 1
				else
					return 0

			when @MODE_HARDWARE_RETRIGGERABLE_ONE_SHOT
				if now < @countValue
					return 1
				else
					return 0
			when @MODE_RATE_GENERATOR
				if ((now % @countValue) == 0) and (now != 0)
					return 1
				else
					return 0
			when @MODE_SQUARE_WAVE
				if (now % @countValue) < ((@countValue + 1) >>> 1)
					return 1
				else
					return 0
			when @MODE_SOFTWARE_TRIGGERED_STROBE, @MODE_HARDWARE_TRIGGERED_STROBE
				if now == @countValue
					return 1
				else
					return 0

			else
				if now >= @countValue
					return 1
				else
					return 0
	getNextTransititionTime: (currentTime) ->
		now = scale64(currentTime - @countStartTime, @PIT_FREQ, Clock.getTickRate())

		switch mode
			when @MODE_RATE_GENERATOR
				base = (now / @countValue) * @countValue

				if (now - base) == 0 && now != 0
					nextTime = base + @countValue
				else
					nextTime = base + @countValue + 1

			when @MODE_SQUARE_WAVE
				base = (now / @countValue) * @countValue
				period2 = ((@countValue + 1) >>> 1)

				if (now - base) < period2
					nextTime = base + period2
				else
					nextTime = base + @countValue
			when @MODE_SOFTWARE_TRIGGERED_STROBE, @MODE_HARDWARE_TRIGGERED_STROBE
				if now < @countValue
					nextTime = @countValue
				else if now == @countValue
					nextTime = @countValue + 1
				else
					return -1

			else #Inclusief MODE_INTERRUPT_ON_TERMINAL_COUNT, MODE_HARDWRE_RETRIGGERABLE_ONE_SHOT
				if now < @countValue
					nextTime = @countValue
				else
					return -1
		nextTime = @countStartTime + scale64(nextTime, Clock.getTickRate(), @PIT_FREQ)

		if nextTime <= @currentTime
			nextTime = @currentTime + 1

		return nextTime

	loadCount: (value) ->
		@nullCount = false

		if value == 0
			value = 0x10000

		@countStartTime = Clock.getTime()
		@countValue = value

		@irqTimerUpdate(@countStartTime)

	irqTimerUpdate: (currentTime) ->
		if not @irqTimer
			return

		expireTime = @getNextTransitionTime(currentTime)
		irqLevel = @getOut(currentTIme)

		@irqDevice.setIRQ(@irq, @irqLevel)

		@nextTransitionTimeValue = expireTime

		if expireTime != -1
			@irqTimer.setExpiry(expireTime)
		else
			@irqTimer.disable()

	getMode: ->
		return @mode

	getInitialCount: ->
		return @countValue

	callback: ->
		@irqTimerUpdate(@nextTransitionValue)

	setIRQTimer: (object) ->
		@irqTimer = object

	setIRQ: (irq) ->
		return irq

	getType: ->
		return 2
