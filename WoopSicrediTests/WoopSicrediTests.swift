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
    
    func testButtonInitiallyDisabled() {
        let buttonEnabled = viewModel.isValid.subscribe(on: scheduler)
        XCTAssertEqual(try buttonEnabled.toBlocking().first(), false)
    }
    
    
    func testButtonEnabledNameOnlyTyped() {
        let isButtonEnabled = viewModel.isValid.subscribe(on: scheduler)
        viewModel.participantName.accept("Alexandre")
        XCTAssertEqual(try isButtonEnabled.toBlocking().first(), false)
    }
    
    func testButtonEnabledEmailOnlyTyped() {
        let isButtonEnabled = viewModel.isValid.subscribe(on: scheduler)
        viewModel.participantEmail.accept("alexandre@email.com")
        XCTAssertEqual(try isButtonEnabled.toBlocking().first(), false)
    }
    
    func testButtonEnabled() {
        let isButtonEnabled = viewModel.isValid.subscribe(on: scheduler)
        viewModel.participantName.accept("Alexandre")
        viewModel.participantEmail.accept("alexandre@email.com")
        XCTAssertEqual(try isButtonEnabled.toBlocking().first(), true)
    }
    
    func testButtonEnabledTextErasedOnName(){
        let isButtonEnabled = viewModel.isValid.subscribe(on: scheduler)
        
        viewModel.participantName.accept("Alexandre")
        viewModel.participantEmail.accept("alexandre@email.com")
        
        viewModel.participantName.accept("")
        
        XCTAssertEqual(try isButtonEnabled.toBlocking().first(), false)
    }
    
    func testButtonEnabledTextErasedOnEmail(){
        let isButtonEnabled = viewModel.isValid.subscribe(on: scheduler)
        
        viewModel.participantName.accept("Alexandre")
        viewModel.participantEmail.accept("alexandre@email.com")
        
        viewModel.participantEmail.accept("")
        
        XCTAssertEqual(try isButtonEnabled.toBlocking().first(), false)
    }
    
    func testButtonEnabledTextErasedOnBoth(){
        let isButtonEnabled = viewModel.isValid.subscribe(on: scheduler)
        
        viewModel.participantName.accept("Alexandre")
        viewModel.participantEmail.accept("alexandre@email.com")
        
        viewModel.participantName.accept("")
        viewModel.participantEmail.accept("")
        
        XCTAssertEqual(try isButtonEnabled.toBlocking().first(), false)
    }
    
    func testButtonNotValidEmail(){
        let isButtonEnabled = viewModel.isValid.subscribe(on: scheduler)
        viewModel.participantName.accept("Alexandre")
        viewModel.participantEmail.accept("alexandre@i")
        XCTAssertEqual(try isButtonEnabled.toBlocking().first(), false)
    }
    
}
