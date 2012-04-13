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

class Timer
	constructor: (@callback, @myOwner) ->
		console.log "timer created"
		@enable = false
		@expireTime = 0

	getType: ->
		return @callback.getType()


	enabled: ->
		return @enable

	disable: ->
		@setStatus(false)

	setExpiry: (@expireTime) ->
		@setStatus(true)

	setStatus: (@enable) ->
		@myOwner.update(@)

	check: (time) ->
		log "Check #{time}"
		if (@enable && time >= @expireTime)
			@disable()
			@callback.callback()
			return true
		else
			return false
