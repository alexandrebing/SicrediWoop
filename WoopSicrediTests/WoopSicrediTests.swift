//
//  WoopSicrediTests.swift
//  WoopSicrediTests
//
//  Created by Alexandre Scheer Bing on 10/11/20.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import WoopSicredi

class WoopSicrediTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var viewModel: EventDetailViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    var testScheduler: TestScheduler!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = EventDetailViewModel(selectedEvent: EventViewModel(event: Event(people: [])))
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        disposeBag = nil
        viewModel = nil
        scheduler = nil
        testScheduler = nil
        super.tearDown()
    }
    
    func testButtonDisabled() {
        let buttonEnabled = viewModel.isValid.subscribe(on: scheduler)
        XCTAssertEqual([try buttonEnabled.toBlocking().first()], [false])
    }
    
    
    func testButtonNameOnlyDisabled() {
        let isButtonEnabled = viewModel.isValid.subscribe(on: scheduler)
        viewModel.participantName.accept("Alexandre")
        XCTAssertEqual([try isButtonEnabled.toBlocking().first()], [false])
    }
    
    func testButtonEmailOnlyDisabled() {
        let isButtonEnabled = viewModel.isValid.subscribe(on: scheduler)
        viewModel.participantEmail.accept("alexandre@iCloud.com")
        XCTAssertEqual([try isButtonEnabled.toBlocking().first()], [false])
    }
    
    func testButtonEnabled() {
        let isButtonEnabled = viewModel.isValid.subscribe(on: scheduler)
        viewModel.participantName.accept("Alexandre")
        viewModel.participantEmail.accept("alexandre@iCloud.com")
        XCTAssertEqual([try isButtonEnabled.toBlocking().first()], [true])
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
