//
//  MainViewModelTests.swift
//  MainViewModelTests
//
//  Created by littlema on 2019/11/3.
//  Copyright © 2019 littema. All rights reserved.
//

import XCTest
@testable import TouristSites

class MainViewModelTests: XCTestCase {
    
    var sut: MainViewModel!
    
    let mockService = MockTouristSitesService()
    
    override func setUp() {
        
        sut = MainViewModel(service: mockService)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_haveFetch_success() {
        
        let stub = StubGenerator()
        
        mockService.result = Result.success(stub.stubNormalResult())
    
        sut.fetchData()
        
        XCTAssert(mockService.isFetchCalled)
    }
    
    func test_fetchNormalStatus_success() {
        
        let stub = StubGenerator()
        
        mockService.result = Result.success(stub.stubNormalResult())
    
        sut.fetchData()
        
        XCTAssertEqual(sut.state.value, MainViewState.normal(isEnd: false))
    }
    
    func test_fetchEmptyStatus_success() {
        
        let stub = StubGenerator()
        
        mockService.result = Result.success(stub.stubEmptyResult())
    
        sut.fetchData()
        
        XCTAssertEqual(sut.state.value, MainViewState.empty)
    }
    
    func test_fetchLoadingStatus_success() {
    
        sut.fetchData()
        
        XCTAssertEqual(sut.state.value, MainViewState.loading(isLoadMore: false))
    }
    
    func test_fetchErrorStatus_success() {
        
        mockService.result = Result.failure(.clientError)
    
        sut.fetchData()
        
        XCTAssertEqual(sut.state.value, MainViewState.apiError)
    }
    
    func test_fetchSplitURL_success() {
        
        let stub = StubGenerator()
        
        mockService.result = Result.success(stub.stubNormalResult())
        
        sut.fetchData()
        XCTAssert(sut.getViewModel(index: 0).photoURL.count == 2)
    }
}

class MockTouristSitesService: TouristSitesService {
    var isFetchCalled = false
    var result: (Result<TouristSiteContent, HTTPError>)?
    
    override func getTouristSites(offset: Int, limit: Int = 10, completion: @escaping ResultTouristSite) {
    
        result != nil ? completion(result!) : nil
        isFetchCalled = true
    }
}

class StubGenerator {
    func stubNormalResult() -> TouristSiteContent {
        let tourist = TouristSiteResult(info: "說明",
                                        stitle: "標題",
                                        longitude: "121",
                                        langinfo: "1",
                                        cat1: "標籤1",
                                        cat2: "標籤2",
                                        file: "https://avatars3.githubusercontent.com/u/13879229.jpghttps://avatars3.githubusercontent.com/u/1387.jpeg",
                                        latitude: "23",
                                        xbody: "介紹",
                                        id: 0,
                                        address: "地址")
        let data = TouristSiteContent(limit: 0,
                                      offset: 10,
                                      count: 300,
                                      sort: "",
                                      results: [tourist])
        return data
    }
    
    func stubEmptyResult() -> TouristSiteContent {
        let data = TouristSiteContent(limit: 0,
                                      offset: 0,
                                      count: 0,
                                      sort: "",
                                      results: [])
        return data
    }
}
