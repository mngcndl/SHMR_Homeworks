//
//  TodoItemTests.swift
//  SHMRweek1Tests
//
//  Created by Liubov Smirnova on 22.06.2024.
//

@testable import SHMRweek1
import XCTest

class TodoItemTests: XCTestCase {
    func testFullJson() {
        let dateNow = Date.now
        let fullItemEntity = TodoItem(
            id: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F",
            text: "This is the test text without commas",
            priority: TodoItem.Priority.high,
            deadline: dateNow,
            done: true,
            creationDate: dateNow,
            editDate: dateNow
        )
        let itemToJson = fullItemEntity.json
        XCTAssertNotNil(itemToJson)
    
        let itemFromJson = TodoItem.parse(jsonData: itemToJson!)
        XCTAssertNotNil(itemFromJson)
    
        XCTAssertEqual(fullItemEntity.id, itemFromJson?.id)
        XCTAssertEqual(fullItemEntity.text, itemFromJson?.text)
        XCTAssertEqual(fullItemEntity.priority, itemFromJson?.priority)
        XCTAssertEqual(fullItemEntity.deadline?.timeIntervalSince1970, itemFromJson?.deadline?.timeIntervalSince1970)
        XCTAssertEqual(fullItemEntity.done, itemFromJson?.done)
        XCTAssertEqual(fullItemEntity.creationDate.timeIntervalSince1970, itemFromJson?.creationDate.timeIntervalSince1970)
        XCTAssertEqual(fullItemEntity.editDate?.timeIntervalSince1970, itemFromJson?.editDate?.timeIntervalSince1970)
    }

    func testFullCSV() {
        let dateNow = Date.now
        let fullItemEntity = TodoItem(
            id: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F",
            text: "This is the test text without commas",
            priority: TodoItem.Priority.high,
            deadline: dateNow,
            done: true,
            creationDate: dateNow,
            editDate: dateNow
        )
    
        let itemToCSV = fullItemEntity.toCSV()
        XCTAssertNotNil(itemToCSV)

        let itemFromCSV = TodoItem.fromCSV(csvString: itemToCSV)
        XCTAssertNotNil(itemFromCSV)

        XCTAssertEqual(fullItemEntity.id, itemFromCSV?.id)
        XCTAssertEqual(fullItemEntity.text, itemFromCSV?.text)
        XCTAssertEqual(fullItemEntity.priority, itemFromCSV?.priority)
        XCTAssertEqual(fullItemEntity.deadline?.timeIntervalSince1970, itemFromCSV?.deadline?.timeIntervalSince1970)
        XCTAssertEqual(fullItemEntity.done, itemFromCSV?.done)
        XCTAssertEqual(fullItemEntity.creationDate.timeIntervalSince1970, itemFromCSV?.creationDate.timeIntervalSince1970)
        XCTAssertEqual(fullItemEntity.editDate?.timeIntervalSince1970, itemFromCSV?.editDate?.timeIntervalSince1970)
    }
    
    func testCommasCSV() {
        let dateNow = Date.now
        let fullItemEntity = TodoItem(
            id: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F",
            text: "This , is the test , text with , commas",
            priority: TodoItem.Priority.high,
            deadline: dateNow,
            done: true,
            creationDate: dateNow,
            editDate: dateNow
        )
    
        let itemToCSV = fullItemEntity.toCSV()
        XCTAssertNotNil(itemToCSV)
    
        let itemFromCSV = TodoItem.fromCSV(csvString: itemToCSV)
        XCTAssertNotNil(itemFromCSV)

        XCTAssertEqual(fullItemEntity.id, itemFromCSV?.id)
        XCTAssertEqual(fullItemEntity.text, itemFromCSV?.text)
        XCTAssertEqual(fullItemEntity.priority, itemFromCSV?.priority)
        XCTAssertEqual(fullItemEntity.deadline?.timeIntervalSince1970, itemFromCSV?.deadline?.timeIntervalSince1970)
        XCTAssertEqual(fullItemEntity.done, itemFromCSV?.done)
        XCTAssertEqual(fullItemEntity.creationDate.timeIntervalSince1970, itemFromCSV?.creationDate.timeIntervalSince1970)
        XCTAssertEqual(fullItemEntity.editDate?.timeIntervalSince1970, itemFromCSV?.editDate?.timeIntervalSince1970)
    }
}
