//
//  FirebaseConfigOutputTransformerFactoryTests.swift
//  
//
//  Created by Lisovyi, Ivan on 27.08.20.
//

import Foundation
import XCTest

@testable import BlazeCore

final class FirebaseConfigOutputTransformerFactoryTests: XCTestCase {
  func testMakeTransformer_whenTransformIsFlattening_shallReturnFlatteningTransformer() {
    // Given
    let transform = Download.Transform.flattening
    
    // When
    let transformer = FirebaseConfigOutputTransformerFactory.makeTransformer(for: transform)
    
    // Then
    XCTAssertNotNil(transformer)
  }
  
  func testMakeTransformer_whenTransformIsNone_shallReturnNil() {
    // Given
    let transform = Download.Transform.none
    
    // When
    let transformer = FirebaseConfigOutputTransformerFactory.makeTransformer(for: transform)
    
    // Then
    XCTAssertNil(transformer)
  }
}
