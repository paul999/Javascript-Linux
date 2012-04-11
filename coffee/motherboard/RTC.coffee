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

		@bootType = null
		@ioportRegistered = false
		@drivesInited = false
		@floppiesInited = false

		@cmosData[@RTC_REG_A] = 0x26
		@cmosData[@RTC_REG_B] = 0x02
		@cmosData[@RTC_REG_C] = 0x00
		@cmosData[@RTC_REG_D] = byte(0x80)


		@periodicCallback = new PeriodicCallback();
		@secondCallback = new SecondCallback();
		@delayedSecondCallback = new DelayedSecondCallback();



	configure: ->
		log "Configure RTC"

	toString: ->
		"RTC"
	initialised: ->
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

		if (component instanceof clock)
			@timeSource = component

		if (@initialised())
			@init()

			@periodicTimer = @timeSource.newTimer(@periodicCallback);
			@secondTimer = @timeSource.newTimer(@secondCallback);
			@delayedSecondTimer = @timeSource.newTimer(@delayedSecondCallback);

			@nextSecondTime = @timeSource.getTime() + (99 * @timeSource.getTickRate()) / 100;
			@delayedSecondTimer.setExpiry(@nextSecondTime);

	init: ->
#        Calendar now = Calendar.getInstance();
#        this.setTime(now);
#        int val = this.toBCD(now.get(Calendar.YEAR) / 100);
		val = null
		@cmosData[@RTC_REG_IBM_CENTURY_BYTE] = val
		@cmosData[@RTC_REG_IBM_PS2_CENTURY_BYTE] = val

		val = 640
		@cmosData[0x15] = byte(val)
		@cmosData[0x16] = byte(val>>>8)

		ramSize = SYS_RAM_SIZE
		val = ramSize / 1024 - 1024
		if (val > 65535)
			val = 65535

		@cmosData[0x17] = byte(val)
		@cmosData[0x18] = byte(val >>> 8)
		@cmosData[0x30] = byte(val)
		@cmosData[0x31] = byte(val >>> 8)

		if (ramSize > 16 * 1024 * 1024)
			val = (ramSize / 65536) - ((16 * 1024 * 1024) / 65536)
		else
			val = 0

		if (val > 65535)
			val = 65535

		@cmosData[0x34] = byte(val)
		@cmosData[0x35] = byte(val >>> 8)

		@cmosData[0x3d] = byte(0x02) #harddrive boot


	ioPortReadByet:(address) ->
		return @cmosIOPortRead(address)

	ioPortReadWord: (address) ->
		return @ioPortReadByte(address) | (@ioPortReadByte(address + 1) << 8)

	ioPortReadLong: (address) ->
		return @ioPortReadWord(address) | (@ioPortReadWord(address + 2)	<< 16)

	ioPortWriteByte: (address, data) ->
		@cmosIOPortWrite(address, data)

	ioPortWriteWord: (address, data) ->
		@ioPortWriteByte(address, data)
		@ioPortWriteByte(address + 1, data >> 8)

	ioPortWriteLong: (addres, data) ->
		@ioPortWriteWord(address, data)
		@ioPortWriteWord(address + 2, data >> 16)

	periodicUpdate: ->
		@timerUpdate()
		@cmosData[@RTC_REG_C] |= 0xc0

		@irqDevice.setIRQ(irq, 1)

	secondUpdate: ->
		if (@cmosData[@RTC_REG_A] & 0x70) != 0x20
			@nextSecondTime += @timeSource.getTickRate()
			@secondTimer.setExpiry(@nextSecondTime)
		else
			@nextSecond()

			if (@cmosData[@RTC_REG_B] & @REG_B_SET) == 0
				@cmosData[@RTC_REG_A] |= @REG_A_UIP

			delay = @timeSource.getTickRate() * 1 / 100

			if (delay < 1)
				delay = 1

			@delayedSecondTimer.setExpiry(@nextSecondTimer + delay)
	delayedSecondUpdate: ->
		if (@cmosData[@RTC_REG_B] & @REG_B_SET) == 0
			@timeToMemory()

		if (@cmosData[@RTC_REG_B] & @REG_B_AIE) != 0 #note, hier beneden moeten bij iedere nog een parameter voor currentTime.get()
			if (((@cmosData[@RTC_SECONDS_ALARM] & 0xc0) == 0xc0 || @cmosData[@RTC_SECONDS_ALARM] == @currentTime.get()) && ((@cmosData[@RTC_MINUTES_ALARM] & 0xc0) == 0xc0 || @cmosData[@RTC_MINUTES_ALARM] == @currentTime.get()) && (( @cmosData[@RTC_HOURS_ALARM] & 0xc0) == 0xc0 || @cmosData[@RTC_HOURS_ALARM] == @currentTime.get()))
				@cmosData[@RTC_REG_C] |= 0xa0
				@irqDevice.setIRQ(irq, 1)

		@cmosData[@RTC_REG_A] &= ~@REG_A_UIP
		@nextSecondTime += @timeSource.getTickRate()
		@secondTimer.setExpiry(@nextSecondTime)

	timerUpdate: (currentTime) ->
		periodCode = @cmosData[@RTC_REG_A] & 0x0f

		if ((periodCode != 0) && (0 != (@cmosData[@RTC_REG_B] & @REG_B_PIE)))
			if (periodCode <= 2)
				periodCode += 7

			period = 1 << (periodCode - 1)

			currentClock = scale64(@currentTime, 32768, int(@timeSource.getTickRate()))
			nextIRQClock = (currentClock & ~(period - 1)) + period
			@nextPeriodicTime = scale64(nextIRQClock, int(@timeSource.getTickRate()), 32768) + 1
			@periodicTimer.setExpiry(@nextPeriodicTime)
		else
			@periodicTimer.disable()
	nextSecond: ->
		@currentTime.add(Calender.SECOND, 1)


	cmosIOPortWrite: (address, data) ->
		if (address & 1) == 0
			@cmosIndex = byte(data & 0x7f)

		switch @cmosIndex
			when @RTC_SECONDS_ALARM, @RTC_MINUTES_ALARM, @RTC_HOURS_ALARM
				@cmosData[@cmosIndex] = byte(data)
			when @RTC_SECONDS, @RTC_MINUTES, @RTC_HOURS, @RTC_DAY_OF_WEEK, @RTC_DAY_OF_MONTH, @RTC_MONTH, @RTC_YEAR
				@cmosData[@cmosIndex] = byte(data)

				if (0 == (@cmosData[@RTC_REG_B] & @REG_B_SET))
					@memoryToTime()
			when @RTC_REG_A
				@cmosData[@RTC_REG_A] = byte((data & ~@REG_A_UIP) | (@cmosData[@RTC_REG_A] & @REG_A_UIP))
				if (@cmosData[@RTC_REG_B] & @REG_B_SET) == 0
					@memoryToTime()
			when @RTC_REG_A
				@cmosData[@RTC_REG_A] = byte((data & ~@REG_A_UIP) | (@cmosData[@RTC_REG_A] & REG_A_UIP))
				@timerUpdate(@timeSource.getTime())

			when @RTC_REG_B
				if (data & @REG_B_SET) == 0
					@cmosData[@RTC_REG_A] &= ~@REG_A_UIP
					data &= ~@REG_B_UIE
				else
					if (@cmosData[@RTC_REG_B] & @REG_B_SET) == 0
						@memoryToTime()
				@cmosData[@RTC_REG_B] = byte(data)
				@timerUpdate(@timeSourece.getTime())
			when @RTC_REG_C, @RTC_REG_D
				return
			else
				@cmosData[@cmosIndex] = byte(data)

	cmosIOPortRead: (address) ->
		if (address & 1) == 0
			return 0xff

		if (@this.cmosIndex == @RTC_REG_C)
			ret = @cmosData[@RTC_REG_C]
			@irqDevice.setIRQ(irq, 0)
			@cmosData[@RTC_REG_C] = 0x00

			return ret
		else
			return @cmosData[@cmosIndex]


	toBCD: (a) ->
		if (@cmosData[@RTC_REG_B] & 0x04) != 0
			return a
		else
			return ((a / 10) << 4) | (a % 10)
	fromBCD: (a) ->
		if (@cmosData[@RTC_REG_B] & 0x04) != 0
			return a
		else
			return ((a >> 4) * 10) + (a & 0x0f)

class TimerResponsive


class PeriodicCallback extends TimerResponsive
	callback: ->
		rtc.periodicUpdate()

	getType: ->
		return 3

class SecondCallback extends TimerResponsive
	callback: ->
		rtc.secondUpdate()

	getType: ->
		return 4

class DelayedSecondCallback extends TimerResponsive
	callback: ->
		rtc.delayedSecondUpdate()

	getType: ->
		return 5

###

NOG in class RTC:
    private void setTime(Calendar date)
    {
        this.currentTime = Calendar.getInstance(date.getTimeZone());
        this.currentTime.setTime(date.getTime());
        this.timeToMemory();
    }
    private void memoryToTime()
    {
        currentTime.set(Calendar.SECOND, this.fromBCD(cmosData[RTC_SECONDS]));
        currentTime.set(Calendar.MINUTE, this.fromBCD(cmosData[RTC_MINUTES]));
        currentTime.set(Calendar.HOUR_OF_DAY, this.fromBCD(cmosData[RTC_HOURS] & 0x7f));
        if (0 == (cmosData[RTC_REG_B] & 0x02) && 0 != (cmosData[RTC_HOURS] & 0x80))
            currentTime.add(Calendar.HOUR_OF_DAY, 12);

        currentTime.set(Calendar.DAY_OF_WEEK, this.fromBCD(cmosData[RTC_DAY_OF_WEEK]));
        currentTime.set(Calendar.DAY_OF_MONTH, this.fromBCD(cmosData[RTC_DAY_OF_MONTH]));
        currentTime.set(Calendar.MONTH, this.fromBCD(cmosData[RTC_MONTH]) - 1);
        currentTime.set(Calendar.YEAR, this.fromBCD(cmosData[RTC_YEAR]) + 2000); //is this offset correct?
    }

    private void timeToMemory()
    {
        cmosData[RTC_SECONDS] = (byte) this.toBCD(currentTime.get(Calendar.SECOND));
        cmosData[RTC_MINUTES] = (byte) this.toBCD(currentTime.get(Calendar.MINUTE));

        if (0 != (cmosData[RTC_REG_B] & 0x02)) / * 24 hour format * /
            cmosData[RTC_HOURS] = (byte) this.toBCD(currentTime.get(Calendar.HOUR_OF_DAY));
        else { / * 12 hour format * /
            cmosData[RTC_HOURS] = (byte) this.toBCD(currentTime.get(Calendar.HOUR));
            if (currentTime.get(Calendar.AM_PM) == Calendar.PM)
                cmosData[RTC_HOURS] |= 0x80;
        }

        cmosData[RTC_DAY_OF_WEEK] = (byte) this.toBCD(currentTime.get(Calendar.DAY_OF_WEEK));
        cmosData[RTC_DAY_OF_MONTH] = (byte) this.toBCD(currentTime.get(Calendar.DAY_OF_MONTH));
        cmosData[RTC_MONTH] = (byte) this.toBCD(currentTime.get(Calendar.MONTH) + 1);
        cmosData[RTC_YEAR] = (byte) this.toBCD(currentTime.get(Calendar.YEAR) % 100);
    }
###
