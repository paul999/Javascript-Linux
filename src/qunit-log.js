$(document).ready(function() {
	// log qunit results to console
	// Expected Format

	// Module: moduleName
	// Test: testName
	// Passed/Failed, Assertion: assertionMessage
	// Passed/Failed, Assertion: assertionMessage, Actual: value, Expected: value
	//
	// ******** Testing Complete ********
	// failed -> 1, passed -> 1, total -> 2, run time -> 32ms

	if(window.console && window.console.log){
		QUnit.log = function(result){
			var msg,
			fail = false;

			if (result.result){
				msg = 'Passed, ';
				return;
			} else {
				msg = 'Failed, ';
				fail = true;
			}

			msg += 'Assertion: ' + result.message;

			if(fail){
				window.console.error(msg);
			} else {
				window.console.log(msg);
			}

			if (result.actual != undefined && result.expected != undefined){
				window.console.log('Actual:' + result.actual);
				window.console.log('Expected:' + result.expected);
			}

		}

		QUnit.done = function (result){
			window.console.log(result);
			window.console.log('******** Testing Complete ******** \nfailed -> ' + result.failed + ', passed -> ' + result.passed + ', total -> ' + result.total + ', run time -> ' + result.runtime + 'ms');
			window.console.log("Tests completed in " + result.runtime + "ms");
		}

		QUnit.testStart = function (test){
			window.console.log('Test: ' + test.name);
		}

		QUnit.moduleStart = function (module){
			window.console.log('Module: ' + module.name);
		}

		QUnit.moduleDone = function (test){
			window.console.log(' \n');
		}
	}
});
