import XCTest

import LaterCLITests

var tests = [XCTestCaseEntry]()
tests += LaterCLITests.allTests()
XCTMain(tests)
