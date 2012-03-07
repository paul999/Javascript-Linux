module("Test microcode execution")
test("Simple microcode", function()
{
	ok(window.testMicroCodes, "Microcodes are required to run the tests for the CPU")

});

test("Large microcode", function()
{
	ok(window.testMicroModes, "Microcodes are required to run the tests for the CPU")
});
