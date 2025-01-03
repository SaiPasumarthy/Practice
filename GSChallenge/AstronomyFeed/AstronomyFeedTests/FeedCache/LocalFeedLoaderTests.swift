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
    
    typealias SaveResult = Error?
    
    func save(_ pictures: [FeedPicture], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let deletionCacheError = error {
                completion(deletionCacheError)
            } else {
                self.cache(pictures, completion: completion)
            }
        }
    }
    
    private func cache(_ pictures: [FeedPicture], completion: @escaping (SaveResult) -> Void) {
        store.insert(pictures) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

protocol FeedStore {
    typealias DeleteCompletion = (Error?) -> Void
    typealias InsertCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeleteCompletion)
    func insert(_ pictures: [FeedPicture], completion: @escaping InsertCompletion)
}

class LocalFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageCachedFeedUponCreation() {
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
        
        expect(sut: sut, toCompletionWith: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut: sut, toCompletionWith: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }

    func test_save_successOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut: sut, toCompletionWith: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }

    func test_save_doesNotReturnDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store)
        var receivedResults = [LocalFeedLoader.SaveResult]()
        
        sut?.save([uniqueItem()], completion: { error in receivedResults.append(error)})
        
        sut = nil
        store.completeDeletion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotReturnInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store)
        var receivedResults = [LocalFeedLoader.SaveResult]()
        
        sut?.save([uniqueItem()], completion: { error in receivedResults.append(error)})
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    func expect(sut: LocalFeedLoader, toCompletionWith expectedError: NSError?, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        var receivedError: Error?
        let exp = expectation(description: "Wait for save command")
        
        sut.save([uniqueItem()]) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as? NSError, expectedError, file: file, line: line)
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackMemoryLeaks(for: store, file: file, line: line)
        trackMemoryLeaks(for: sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private class FeedStoreSpy: FeedStore {
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
