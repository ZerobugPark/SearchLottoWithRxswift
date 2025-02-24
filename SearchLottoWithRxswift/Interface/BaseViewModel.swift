//
//  BaseViewModel.swift
//  SearchLottoWithRxswift
//
//  Created by youngkyun park on 2/24/25.
//

import Foundation


protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}
