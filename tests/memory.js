QUnit.module("Test PC memory")

QUnit.test("Memory Length", function()
{
	setup()

	window.pc.create()

	equal(window.pc.getMemoryLength(), 0x2000010, 'Memory length Array')
	equal(window.pc.getMemoryLength(8),0x2000010, 'Memory length uint8')
	equal(window.pc.getMemoryLength(16), 0x2000010/2, 'Memory length uint16')
	equal(window.pc.getMemoryLength(32), 0x2000010/4, 'Memory length uint32')
});

QUnit.test("Check emptyness", function()
{
	setup()
	window.pc.create()

	equal(window.pc.getMemoryOffset(8, 0), 0, "Test memory 0")
	equal(window.pc.getMemoryOffset(8, 512), 0, "Test memory 512")
	equal(window.pc.getMemoryOffset(8, 0x10000), 0, "Test memory 0x00000")
});
QUnit.test("Save memory", function()
{
	setup()
	window.pc.create()

	ok(!window.pc.getMemoryOffset(8, 0x50001A), "Test memory over max size")

	window.pc.saveMemory(window.start, window.start.length, 0x10000)
	equal(window.pc.getMemoryOffset(8, 0), 0, "Test memory 0")
	equal(window.pc.getMemoryOffset(8, 0x10000), window.start[0], "Test memory 0x00000")

	equal(window.pc.getMemoryOffset(8, 0x10000 + 10), window.start[10], "Test memory 0x00000 + 10")

	setup()
	window.pc.create()

	raises(function(){window.pc.saveMemory(window.start, window.start.length, SYS_RAM_SIZE + 10)}, MemoryOutOfBound, "Saving memory out of bound")

	equal(window.pc.getMemoryOffset(8, 0), 0, "Test memory 0")
	equal(window.pc.getMemoryOffset(8, 0x10000), 0, "Test memory 0x00000")

	equal(window.pc.getMemoryOffset(8, 0x10000 + 10), 0, "Test memory 0x00000 + 10")

	ok(!window.pc.getMemoryOffset(8, 0x50001A), "Test memory over max size with data set")

});
