//
//  ImageLoaderTests.swift
//  CoinMarketCapAppTests
//
//  Created by André Costa Dantas on 09/02/26.
//

import XCTest
@testable import CoinMarketCapApp
import UIKit

final class ImageLoaderTests: XCTestCase {
    
    var sut: URLSessionImageLoader!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        sut = URLSessionImageLoader(session: mockSession)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testLoadImage_WithValidData_ReturnsImage() {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        let imageData = createImageData()
        mockSession.mockData = imageData
        mockSession.mockResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = expectation(description: "Image loaded")
        var loadedImage: UIImage?
        
        // When
        sut.loadImage(from: url) { image in
            loadedImage = image
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertNotNil(loadedImage)
        XCTAssertEqual(mockSession.dataTaskCallCount, 1)
    }
    
    func testLoadImage_WithNetworkError_ReturnsNil() {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        mockSession.mockError = NSError(domain: "TestError", code: -1009)
        
        let expectation = expectation(description: "Image load completed")
        var loadedImage: UIImage?
        
        // When
        sut.loadImage(from: url) { image in
            loadedImage = image
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertNil(loadedImage)
    }
    
    func testLoadImage_WithHTTPError_ReturnsNil() {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        mockSession.mockResponse = HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockData = Data()
        
        let expectation = expectation(description: "Image load completed")
        var loadedImage: UIImage?
        
        // When
        sut.loadImage(from: url) { image in
            loadedImage = image
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertNil(loadedImage)
    }
    
    func testLoadImage_WithInvalidImageData_ReturnsNil() {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        mockSession.mockData = Data([0x00, 0x01, 0x02]) // Invalid image data
        mockSession.mockResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = expectation(description: "Image load completed")
        var loadedImage: UIImage?
        
        // When
        sut.loadImage(from: url) { image in
            loadedImage = image
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertNil(loadedImage)
    }
    
    func testLoadImage_WithEmptyData_ReturnsNil() {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = expectation(description: "Image load completed")
        var loadedImage: UIImage?
        
        // When
        sut.loadImage(from: url) { image in
            loadedImage = image
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertNil(loadedImage)
    }
    
    func testLoadImage_SetsCorrectCachePolicy() {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        mockSession.mockData = createImageData()
        mockSession.mockResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = expectation(description: "Image loaded")
        
        // When
        sut.loadImage(from: url) { _ in
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertEqual(mockSession.lastRequest?.cachePolicy, .returnCacheDataElseLoad)
    }
    
    func testLoadImage_SetsCorrectTimeout() {
        // Given
        let url = URL(string: "https://example.com/image.png")!
        mockSession.mockData = createImageData()
        mockSession.mockResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = expectation(description: "Image loaded")
        
        // When
        sut.loadImage(from: url) { _ in
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertEqual(mockSession.lastRequest?.timeoutInterval, 10)
    }
    
    // MARK: - Helper Methods
    
    private func createImageData() -> Data {
        // Create a minimal valid PNG image data
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.pngData() ?? Data()
    }
}

// MARK: - Mock URLSession

final class MockURLSession: URLSession {
    
    var dataTaskCallCount = 0
    var lastRequest: URLRequest?
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        dataTaskCallCount += 1
        lastRequest = request
        
        // Call completion asynchronously to simulate real behavior
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            completionHandler(self.mockData, self.mockResponse, self.mockError)
        }
        
        return MockURLSessionDataTask()
    }
}

final class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {
        // Mock implementation - do nothing
    }
}
