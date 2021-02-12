//
//  Kursy_Walut_Tests.swift
//  Kursy Walut Tests
//
//  Created by Maciej Piechoczek on 11/02/2021.
//

import XCTest
@testable import Kursy_Walut

class Kursy_Walut_Tests: XCTestCase {

    var networkService: NetworkService!
    var parsingService: ParsingService!
    
    let emptyData = Data()

    let completeTableData =  Data("""
    [
      {
        "table": "A",
        "no": "028/A/NBP/2021",
        "effectiveDate": "2021-02-11",
        "rates": [
          {
            "currency": "bat (Tajlandia)",
            "code": "THB",
            "mid": 0.1243
          },
          {
            "currency": "dolar amerykański",
            "code": "USD",
            "mid": 3.7117
          },
          {
            "currency": "dolar australijski",
            "code": "AUD",
            "mid": 2.8746
          }
        ]
      }
    ]
    """.utf8)

    let missingFieldCurrencyData = Data("""
    {
      "table": "C",
      "currency": "dolar amerykański",
      "code": "USD",
      "rates": [
        {
          "effectiveDate": "2021-02-11",
          "bid": 3.6583,
          "ask": 3.7323
        }
      ]
    }
    """.utf8)

    override func setUp() {
        super.setUp()
        networkService = NetworkService()
        parsingService = ParsingService()
    }

    override func tearDown() {
        networkService = nil
        parsingService = nil
        super.tearDown()
    }

    func testTableFetching() {
        let promise = expectation(description: "200")
        networkService.getRatesForTable("A") { result in
            switch result {
            case .success(let apiResult):
                if apiResult.responseCode == 200 {
                    promise.fulfill()
                }
            case.failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }

    func testWrongTableFetching() {
        let promise = expectation(description: "400")
        networkService.getRatesForTable("F") { result in
            switch result {
            case .success(let apiResult):
                if apiResult.responseCode == 400 {
                    promise.fulfill()
                }
            case.failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }

    func testEmptyTableFetching() {
        let promise = expectation(description: "404")
        networkService.getRatesForTable("") { result in
            switch result {
            case .success(let apiResult):
                if apiResult.responseCode == 404 {
                    promise.fulfill()
                }
            case.failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }

    func testCurrencyFetching() {
        let promise = expectation(description: "200")
        networkService.getCurrencyDetails(
            table: "C",
            code: "USD",
            startDate: "2021-02-11",
            endDate: "2021-02-11"
        ) { result in
            switch result {
            case .success(let apiResult):
                if apiResult.responseCode == 200 {
                    promise.fulfill()
                }
            case.failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }

    func testWrongCurrencyFetching() {
        let promise = expectation(description: "404")
        networkService.getCurrencyDetails(
            table: "C",
            code: "OOO",
            startDate: "2021-02-11",
            endDate: "2021-02-11"
        ) { result in
            switch result {
            case .success(let apiResult):
                if apiResult.responseCode == 404 {
                    promise.fulfill()
                }
            case.failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }

    func testEmptyDateCurrencyFetching() {
        let promise = expectation(description: "404")
        networkService.getCurrencyDetails(
            table: "C",
            code: "OOO",
            startDate: "2021-02-11",
            endDate: ""
        ) { result in
            switch result {
            case .success(let apiResult):
                if apiResult.responseCode == 404 {
                    promise.fulfill()
                }
            case.failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }

    func testCompleteTableData() {
        let table = parsingService.parseTable(from: completeTableData)
        XCTAssertNotNil(table)
    }

    func testEmptyData() {
        let table = parsingService.parseTable(from: emptyData)
        XCTAssertNil(table)
    }

    func testMissingCurrecyFieldData() {
        let currency = parsingService.parseCurrency(from: missingFieldCurrencyData)
        XCTAssertNil(currency)
    }
}
