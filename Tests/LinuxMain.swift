import XCTest
@testable import DMSwiftTests

XCTMain([
    testCase(DMSwiftTests.allTests),
    testCase(DownloadTaskTests.allTests),
    testCase(DownloadQueueTests.allTests),
    testCase(DownloadableTaskTests.allTests),
    testCase(DownloadOpeartionTests.allTests),
    testCase(PostProcessingOperationTests.allTests),
    testCase(PostProcessQueueTests.allTests),
    testCase(GroupPostProcessingOperationTests.allTests),
    testCase(FileStorageManageableTests.allTests),
    testCase(FileManagerExtensionTests.allTests),
    testCase(FileReadingTests.allTests),
    testCase(FileWritingTests.allTests),
])
