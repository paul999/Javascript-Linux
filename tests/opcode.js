module("Test opcode convertor")

test("Simple opcode", function()
{
	ok(window.testOpCodes, "Opcodes are required to run the tests for the CPU")

	setup()
	window.pc.create()

	runCode(window.testOpCodes[0], window.resultOpCodes[0])
});

function runCode(cd, cd2)
{
	var oldram = SYS_RAM_SIZE
	for (var i = 0; i < cd.length; i++)
	{
		var bt;

//		SYS_RAM_SIZE = 1024 * 2

		window.pc.resetMemory()

		console.log("saving: " + cd[i])

		window.pc.saveMemory(cd[i], cd[i].length, 0x10000)

		bt = new ByteSourceWrappedMemory()
		bt.set(0x10000)

		var p = new ProtectedModeUDecoder()

		p = p.decodeProtected(bt, true, 1)



		console.log("Length: " + p.getLength())

		var t = new OptimisedCompiler()

		t.buildCodeBlockBuffers(p)
		t = t.bufferMicrocodes

		ok(t.length != 0, "Testing microcode length for test + " + i)
		equal(t.length, cd2[i].length, "Total microcode length for test + " + i)

		for (var j = 0; j < t.length; j++)
		{
			equal(t[j], cd2[i][j], "Testing microcode result for opcode for test + " + i + " set " + j)
		}
	}
	SYS_RAM_SIZE = oldram
}

test("Large opcode", function()
{
	ok(window.testOpCodes, "Opcodes are required to run the tests for the CPU")

	setup()
	window.pc.create()

	runCode(window.testOpCodes[1], window.resultOpCodes[1])

});
