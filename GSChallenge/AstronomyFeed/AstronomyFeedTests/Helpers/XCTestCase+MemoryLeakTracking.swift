//
//  XCTestCase+MemoryLeakTracking.swift
//  AstronomyFeedTests
//
//  Created by Sai Pasumarthy on 30/12/24.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeaks(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
