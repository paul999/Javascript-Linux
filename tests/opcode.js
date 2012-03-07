module("Test opcode convertor")

test("Simple opcode", function()
{
	ok(window.testOpCodes, "Opcodes are required to run the tests for the CPU")

	setup()
	window.pc.create()

	for (var i = 0; i < window.testOpCodes[0].length; i++)
	{
		var bt;

		window.pc.resetMemory()

		console.log("saving: " + window.testOpCodes[0][i])

		window.pc.saveMemory(window.testOpCodes[0][i], window.testOpCodes[0][i].length, 0x10000)

		bt = new ByteSourceWrappedMemory()
		bt.set(0x10000)

		var p = new ProtectedModeUDecoder()

		p = p.decodeProtected(bt, true, 1000)



		console.log("Length: " + p.getLength())

		t = new OptimisedCompiler()

		t.buildCodeBlockBuffers(p)
		t = t.bufferMicrocodes

		ok(t.length != 0, "Testing microcode length for test + " + i)
		equal(t.length, window.resultOpCodes[0][i].length, "Total microcode length for test + " + i)

		for (var j = 0; j < window.resultOpCodes[0][i].length; j++)
		{
			equal(t[j], window.resultOpCodes[0][i][j], "Testing microcode result for opcode for test + " + i + " set " + j)
		}
	}
});

test("Large opcode", function()
{
	ok(window.testOpCodes, "Opcodes are required to run the tests for the CPU")

	setup()
	window.pc.create()
	window.pc.resetMemory()

});
