//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Rajneesh Biswal on 17/03/23.
//

import XCTest
@testable import Networking

class ContainerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_RegisterationOfObjectWithNoParameters() throws {
        let sut = Container()
        sut.register(MathsService.self) { MathsServiceObject() }
        XCTAssertNotNil(sut)
        let mathsService: MathsService? = sut.get()
        XCTAssertNotNil(mathsService)
    }

    func test_RegisterationOfObjectWithContainerPassedAsArg() throws {
        let testContainer = Container()
        testContainer.register(MathsService.self) {  MathsServiceObject(container: $0) }
        let mathsService: MathsService = testContainer.getIfResgistered()
        XCTAssertEqual(mathsService.add(num1: 1, num2: 2), 3)
        XCTAssertEqual(mathsService.subtract(num1: 1, num2: 2), -1)
    }

    func test_ObjectNotRegistered() {
        let testContainer = Container()
        let mathsService: Codable? = testContainer.get()
        XCTAssertNil(mathsService)
    }

    func test_CheckExitanceOfRegisteredObject() {
        let testContainer = Container()
        testContainer.register(MathsService.self) {  MathsServiceObject(container: $0) }
        XCTAssertFalse(testContainer.testHooks.checkIfAlreadyRegistered("XYZ"))
        XCTAssertTrue(testContainer.testHooks.checkIfAlreadyRegistered(String(describing: MathsService.self)))
    }

    func test_identifierOfObject() {
        let testContainer = Container()
        let mathsServiceObject = MathsServiceObject(container: testContainer)
        XCTAssertEqual(testContainer.testHooks.identifier(MathsService.self),
                       String(describing: MathsService.self))
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

protocol MathsService {
    func add(num1: Int, num2: Int) -> Int
    func subtract(num1: Int, num2: Int) -> Int
}

final class MathsServiceObject: MathsService {

    private let container: Container
    
    init(container: Container) {
        self.container = container
    }

    init() {
        self.container = .init()
    }

    func add(num1: Int, num2: Int) -> Int {
        num1 + num2
    }
    
    func subtract(num1: Int, num2: Int) -> Int {
        num1 - num2
    }
}
