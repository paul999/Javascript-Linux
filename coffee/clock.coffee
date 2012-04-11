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

class clock
	constructor: ->
		log "create clock"
		@IPS = proc.IPS
		@NSPI = 10*1000000000/@IPS
		@ticksEnabled = false
		@ticksOffset = 0
		@ticksStatic = 0
		@currentTime = @getSystemTimer();
		@totalTicks = 0
		@timers = new buckets.PriorityQueue();

	initialised: ->
		return true

	process: ->
		tempTimer = @timers.peek()

		if ((tempTimer == null) || !tempTimer.check(getTime()))
			return false
		else
			return true


	updateAndProcess: (instructions) ->
		@totalTicks += instructions
		@currentTime += instructions * @NSPI
		@process()

	newTimer: (object) ->
		if ( !(object instanceof TimerResponsive))
			return false

		return new Timer(object, this);

	update: (object) ->
		if ( !(object instanceof Timer))
			return false

		@timers.remove(object);

		if (object.enabled())
			@timers.offer(object)

	getTime: ->
		if (@ticksEnabled)
			return @getRealTime() + @ticksOffset
		else
			return @ticksStatic

	getRealTime: ->
		return @realTime

	getTickRate: ->
		return @IPS * 10

	getTicks: ->
		return @totalTicks

	pause: ->
		if (@ticksEnabled)
			@ticksStatic = @getTime()
			@ticksEnabled = false

	resume: ->
		if (!@ticksEnabled)
			@ticksOffset = @ticksStatic - @getRealTime()
			@ticksEnabled = true

	reset: ->
		@pause()
		@ticksOffset = 0
		@ticksStatic = 0

	getSystemTimer: ->
		#return System.nanoTime()


###
    public void updateNowAndProcess() {
        if (REALTIME) {
            currentTime = getSystemTimer();
            if (process())
            {
                return;
            }

            Timer tempTimer;
            synchronized (this)
            {
                tempTimer = timers.peek();
            }
            long expiry = tempTimer.getExpiry();
            try
            {
                Thread.sleep(Math.min((expiry - getTime()) / 1000000, 100));
            } catch (InterruptedException ex)
            {
                Logger.getLogger(VirtualClock.class.getName()).log(Level.SEVERE, null, ex);
            }
            totalTicks += (expiry - ticksOffset - currentTime)/NSPI;
            currentTime = getSystemTimer();

            tempTimer.check(getTime());
        } else {
            Timer tempTimer;
            synchronized (this)
            {
                tempTimer = timers.peek();
            }
            long expiry = tempTimer.getExpiry();
            try
            {
                Thread.sleep(Math.min((expiry - getTime()) / 1000000, 100));
            } catch (InterruptedException ex)
            {
                Logger.getLogger(VirtualClock.class.getName()).log(Level.SEVERE, null, ex);
            }
            totalTicks += (expiry - ticksOffset - currentTime)/NSPI;
            currentTime = expiry -ticksOffset;
            //System.out.println("New time during HALT: " + (expiry - ticksOffset));
            tempTimer.check(getTime());
        }
    }
    ###
