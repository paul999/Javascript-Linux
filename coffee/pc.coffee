class pc
	constructor: ->
		console.log "pc.create"
		@items = new Array()
		@count = 0
		@configured = false
		@started = false

		@add(new cpu)
		@add(new term)
	add: (itm) ->
		@items[@count] = itm
		@count++
	start: ->
		if (!@configured)
			@configure()
		if (@started)
			throw new "Already started"

		console.log "pc.start"
		for itm in @items
			do (itm) ->
				try
					if (itm)
						itm.start()
				catch e
					console.log e
		@started = true
		alert "PC started"
		""
	stop: ->
		console.log "pc.stop"
		for itm in @items
			do (itm) ->
				try
					if (itm)
						itm.stop()
				catch e
					console.log e
		""
	configure: ->
		if (@configured)
			throw "Already configured"

		for itm in @items
			do (itm) ->
				try
					if (itm)
						itm.configure()
				catch e
					console.log e
		@configured = true
		""
