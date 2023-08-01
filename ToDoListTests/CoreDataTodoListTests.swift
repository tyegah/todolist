//
//  CoreDataTodoListTests.swift
//  ToDoListTests
//
//  Created by Ty Septiani on 01/08/23.
//

import XCTest
@testable import ToDoList

final class CoreDataTodoListTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieveWithResult: .success([]))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieveWithResult: .success([]))
        expect(sut, toRetrieveWithResult: .success([]))
    }
    
    func test_retrieve_deliversFoundValueOnNonEmptyCache() {
        let sut = makeSUT()
        let item = makeLocalItem()
        let insertionError:Error? = insert(item, into: sut)
        XCTAssertNil(insertionError)
        
        expect(sut, toRetrieveWithResult: .success([item]))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let item = makeLocalItem()
        let insertionError:Error? = insert(item, into: sut)
        XCTAssertNil(insertionError)
        expect(sut, toRetrieveWithResult: .success([item]))
        expect(sut, toRetrieveWithResult: .success([item]))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        let item = makeLocalItem(id: UUID())
        let insertionError:Error? = insert(item, into: sut)
        XCTAssertNil(insertionError)
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        let uuid = UUID()
        let uuid2 = UUID()
        let item1 = makeLocalItem(id: uuid)
        let item2 = makeLocalItem(id: uuid2)
        let insertionError1:Error? = insert(item1, into: sut)
        let insertionError2: Error? = insert(item2, into: sut)
        XCTAssertNil(insertionError1)
        XCTAssertNil(insertionError2)
        expect(sut, toRetrieveWithResult: .success([item1, item2]))
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        let deletionError = delete(makeLocalItem(), from: sut)
        XCTAssertNil(deletionError)
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        let item = makeLocalItem()
        let insertionError = insert(item, into: sut)
        XCTAssertNil(insertionError)
        let deletionError = delete(item, from: sut)
        XCTAssertNil(deletionError)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let item = makeLocalItem()
        let deletionError1 = delete(item, from: sut)
        let deletionError2 = delete(item, from: sut)
        XCTAssertNil(deletionError1)
        XCTAssertNil(deletionError2)
    }
    
    func test_delete_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let item1 = makeLocalItem()
        let item2 = makeLocalItem()
        insert(item1, into: sut)
        insert(item2, into: sut)
        let deletionError1 = delete(item1, from: sut)
        XCTAssertNil(deletionError1)
        expect(sut, toRetrieveWithResult: .success([item2]))
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()
        let item = makeLocalItem()
        let op1 = expectation(description: "Operation 1")
        sut.insert(item) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.delete(item) { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(item) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        wait(for: [op1, op2, op3], timeout: 5.0)
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order.")
    }
    
    private func makeLocalItem(id: UUID = UUID()) -> LocalTodoItem {
        return LocalTodoItem(id: id, title: "Title 1", desc: "desc 1", completed: false, removed: false, dueDate: Date())
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataTodoListStore {
        let storeBundle = Bundle(for: CoreDataTodoListStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")

        let sut = try! CoreDataTodoListStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    @discardableResult
    private func delete(_ item: LocalTodoItem, from sut: TodoListStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for deletion")
        var deletionError: Error?
        sut.delete(item) { result in
            switch result {
            case let .failure(error):
                deletionError = error
            default: break
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    @discardableResult
    private func insert(_ item: LocalTodoItem, into sut: TodoListStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for insertion")
        var insertionError: Error?
        sut.insert(item) { result in
            switch result {
            case let .failure(error):
                insertionError = error
            default: break
            }
        
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    private func expect(_ sut: TodoListStore, toRetrieveWithResult expectedResult: Result<[LocalTodoItem], Error>, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for retrieval")
        let predicate = NSPredicate(format: "removed == NO")
        sut.retrieve(predicate) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError?, expectedError as NSError?)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }


}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        // The instance needs to be weak to avoid retain cycle inside the teardown block
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
