//
//  LocalFeedLoaderTests.swift
//  AstronomyFeedTests
//
//  Created by Sai Pasumarthy on 02/01/25.
//

import XCTest
import AstronomyFeed

class LocalFeedLoader {
    private let store: FeedStore
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ pictures: [FeedPicture], completion: @escaping (Error?) -> Void) {
        store.deleteCachedFeed { [unowned self] error in
            if error == nil {
                self.store.insert(pictures, completion: completion)
            } else {
                completion(error)
            }
        }
    }
}
class FeedStore {
    typealias DeleteCompletion = (Error?) -> Void
    typealias InsertCompletion = (Error?) -> Void
    
    enum ReceivedMessage: Equatable {
        case deleteCachedPicture
        case insert(pictures: [FeedPicture])
    }

    var deleteCompletions = [DeleteCompletion]()
    var insertCompletions = [InsertCompletion]()
    
    var receivedMessages = [ReceivedMessage]()
    
    func deleteCachedFeed(completion: @escaping DeleteCompletion) {
        receivedMessages.append(.deleteCachedPicture)
        deleteCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deleteCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deleteCompletions[index](nil)
    }
    
    func insert(_ pictures: [FeedPicture], completion: @escaping InsertCompletion) {
        insertCompletions.append(completion)
        receivedMessages.append(.insert(pictures: pictures))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertCompletions[index](nil)
    }
}
class LocalFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotDeleteCachedFeedUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()

        sut.save([uniqueItem()]) { _ in }
                
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPicture])
    }

    func test_save_doesNotRequestInsertCacheOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save([uniqueItem()]) { _ in }
        
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPicture])
    }
    
    func test_save_requestNewCacheInsertionOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()
        let pictures = [uniqueItem()]
        
        sut.save(pictures) { _ in }
        
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPicture, .insert(pictures: pictures)])
    }

    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        var receivedError: Error?
        let exp = expectation(description: "Wait for save command")
        
        sut.save([uniqueItem()]) { error in
            receivedError = error
            exp.fulfill()
        }
        
        store.completeDeletion(with: deletionError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as? NSError, deletionError)
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        var receivedError: Error?
        let exp = expectation(description: "Wait for save command")
        
        sut.save([uniqueItem()]) { error in
            receivedError = error
            exp.fulfill()
        }
        
        store.completeDeletionSuccessfully()
        store.completeInsertion(with: insertionError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as? NSError, insertionError)
    }

    func test_save_successOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        var receivedError: Error?
        let exp = expectation(description: "Wait for save command")
        
        sut.save([uniqueItem()]) { error in
            receivedError = error
            exp.fulfill()
        }
        
        store.completeDeletionSuccessfully()
        store.completeInsertionSuccessfully()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNil(receivedError)
    }

    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        trackMemoryLeaks(for: store)
        trackMemoryLeaks(for: sut)
        
        return (sut, store)
    }
    
    private func uniqueItem() -> FeedPicture {
        FeedPicture(
            date: "12-21-2024",
            explanation: "a explanation",
            title: "a title",
            url: "http://www.a-url.com"
        )
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
}
