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

class RTC
	constructor: (@ioPort, @irq) ->
		log "Created RTC with Port #{ioPort} and irq #{irq}"

		@RTC_SECONDS = 0
		@RTC_SECONDS_ALARM = 1
		@RTC_MINUTES = 2
		@RTC_MINUTES_ALARM = 3
		@RTC_HOURS = 4
		@RTC_HOURS_ALARM = 5
		@RTC_ALARM_DONT_CARE = 0xc0
		@RTC_DAY_OF_WEEK = 6
		@RTC_DAY_OF_MONTH = 7
		@RTC_MONTH = 8
		@RTC_YEAR = 9
		@RTC_REG_EQUIPMENT_BYTE = 0x14
		@RTC_REG_IBM_CENTURY_BYTE = 0x32
		@RTC_REG_IBM_PS2_CENTURY_BYTE = 0x37
		@RTC_REG_A = 10
		@RTC_REG_B = 11
		@RTC_REG_C = 12
		@RTC_REG_D = 13
		@REG_A_UIP = 0x80
		@REG_B_SET = 0x80
		@REG_B_PIE = 0x40
		@REG_B_AIE = 0x20
		@REG_B_UIE = 0x10

		@cmosData = new Array()
		@cmosIndex = null
		@currentTime = null
		@periodicTimer = null
		@nextPeriodicTime = null

		@secondTimer = null
		@delayedSecondTimer = null
		@nextSecondTime = null

		@periodicCallback = null
		@secondCallback = null
		@delayedSecondCallback = null
		@irqDevice = null
		@timeSource = null
		@ioPortBase = @ioPort
		@bootType = null
		@ioportRegistrered = null
		@drivesInited = null
		@floppiesInited = null



	configure: ->
		log "Configure RTC"

	toString: ->
		"RTC"
	initialised: ->
		#return true
		return ((@irqDevice != null) && @ioPortRegistered)

	ioPortsRequested: ->
		return [@ioPortBase, @ioPortBase+1]

	acceptComponent: (component) ->
		log "acceptComponent on RTC with #{component}"
		if (component instanceof InterruptController) && component.initialised()
			@irqDevice = component

		if (component instanceof IOPortHandler) && component.initialised()
			component.registerIOPortCapable(@)
			@ioPortRegistered = true

		if (@initialised())
			@init()

#            periodicTimer = timeSource.newTimer(periodicCallback);
#            secondTimer = timeSource.newTimer(secondCallback);
#            delayedSecondTimer = timeSource.newTimer(delayedSecondCallback);

#            nextSecondTime = timeSource.getTime() + (99 * timeSource.getTickRate()) / 100;
#            delayedSecondTimer.setExpiry(nextSecondTime);

	init: ->
#        Calendar now = Calendar.getInstance();
#        this.setTime(now);
#        int val = this.toBCD(now.get(Calendar.YEAR) / 100);
		val = null
		@cmosData[@RTC_REG_IBM_CENTURY_BYTE] = val
		@cmosData[@RTC_REG_IBM_PS2_CENTURY_BYTE] = val

		val = 640
		@cmosData[0x15] = val
		@cmosData[0x16] = (val>>>8)

		ramSize = SYS_RAM_SIZE
		val = ramSize / 1024 - 1024
		if (val > 65535)
			val = 65535

		@cmosData[0x17] = val
		@cmosData[0x18] = val >>> 8
		@cmosData[0x30] = val
		@cmosData[0x31] = val >>> 8

		if (ramSize > 16 * 1024 * 1024)
			val = (ramSize / 65536) - ((16 * 1024 * 1024) / 65536)
		else
			val = 0

		if (val > 65535)
			val = 65535

		@cmosData[0x34] = val
		@cmosData[0x35] = val >>> 8
