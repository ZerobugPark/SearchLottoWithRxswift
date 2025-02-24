//
//  LottoViewModel.swift
//  SearchLottoWithRxswift
//
//  Created by youngkyun park on 2/24/25.
//

import Foundation

import RxSwift
import RxCocoa


class LottoViewModel: BaseViewModel {

    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let numbers: BehaviorRelay<[Int]>
    }
    
    let disposeBag = DisposeBag()
    
    private var numbers: [Int] = []
    private var latestTimes: Int = 0
    
    init() {
        print("LottoViewModel Init")
      
    }
    
    func transform(input: Input) -> Output {
        
        let outputNumbers = BehaviorRelay(value: numbers)
        
        
        input.viewDidLoad.subscribe(with: self) { owner, _ in
            
            owner.calcLatestTimes()
            
            
        
            outputNumbers.accept(owner.numbers)
            
        }.disposed(by: disposeBag)
        
        return Output(numbers: outputNumbers)
    }
    
    deinit {
        print("LottoViewModel DeInit")
    }
    
}

 
extension LottoViewModel {
    

    private func calcLatestTimes() {

        let now = Date()
        let calendar = Calendar.current
        
        var startDay = DateComponents()
        startDay.day = 07
        startDay.month = 12
        startDay.year = 2002
        
        if let day = calendar.date(from: startDay) {
            startDay = calendar.dateComponents([.day], from: day, to: now)
            latestTimes = (Int(startDay.day!) / 7) + 1
            //print(latestTimes)
        } else {
            latestTimes = 1
        }
        
        numbers = Array(1...latestTimes).reversed()
        
    }
    
}

