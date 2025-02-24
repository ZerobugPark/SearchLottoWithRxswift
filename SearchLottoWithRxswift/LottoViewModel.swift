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
        let pickerViewSelected: ControlEvent<(row: Int, component: Int)>
        let basicButtonTapped:  ControlEvent<Void>
        let singleButtonTapped:  ControlEvent<Void>
    }
    
    struct Output {
        let numbers: BehaviorRelay<[Int]>
        let settingView: BehaviorRelay<UISetting>
        let textField: BehaviorRelay<String>
    }
    
    let disposeBag = DisposeBag()
    
    private var numbers: [Int] = []
    private var latestTimes: Int = 0
    private var uiSet = UISetting()
    
    init() {
        print("LottoViewModel Init")
      
    }
    
    func transform(input: Input) -> Output {
        
        let outputNumbers = BehaviorRelay(value: numbers)
        let outputLottery = BehaviorRelay(value: uiSet)
        let outputString = BehaviorRelay(value: "")
        
        input.viewDidLoad.subscribe(with: self) { owner, _ in
            
            owner.calcLatestTimes()
            
            NetworkManager.shared.callRequest(no: owner.latestTimes, type: Lottery.self).subscribe(with: self) { owner, value in
                let outputData = owner.outputStruct(data: value)
                
                let drwNo = value.drwNo.formatted()
                outputString.accept(drwNo)
                outputLottery.accept(outputData)
            } onError: { owner, error in
                print("onError", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }.disposed(by: owner.disposeBag)

        
            outputNumbers.accept(owner.numbers)
            
        }.disposed(by: disposeBag)
        
        input.pickerViewSelected.bind(with: self) { owner, value in
            let drwNo =  owner.numbers[value.row].formatted()
            outputString.accept(drwNo)
        }.disposed(by: disposeBag)
        
        input.basicButtonTapped.withLatestFrom(input.pickerViewSelected).flatMap {
            NetworkManager.shared.callRequest(no: self.numbers[$0.0], type: Lottery.self).debug("net")
        }.debug("basicButton").subscribe(with: self) { owner, value in
            let outputData = owner.outputStruct(data: value)
            outputLottery.accept(outputData)
        } onError: { owner, error in
            print(error)
        } onCompleted: { owner in
            print("onCompleted")
        } onDisposed: { owner in
            print("onDisposed")
        }.disposed(by: disposeBag)
        
        input.singleButtonTapped.withLatestFrom(input.pickerViewSelected).flatMap {
            NetworkManager.shared.singleCallRequest(no: self.numbers[$0.0], type: Lottery.self).debug("net")
        }.debug("single").subscribe(with: self) { owner, value in
            let outputData = owner.outputStruct(data: value)
            outputLottery.accept(outputData)
        } onError: { owner, error in
            print(error)
        } onCompleted: { owner in
            print("onCompleted")
        } onDisposed: { owner in
            print("onDisposed")
        }.disposed(by: disposeBag)

        
   
        
        return Output(numbers: outputNumbers, settingView: outputLottery, textField: outputString)
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

extension LottoViewModel {

    struct UISetting {
        var numbers: [Int] = [0,0,0,0,0,0,0,0]
        var timesLabel: String = ""
        var dateLabel: String = ""
    }
    
    
    private func outputStruct(data: Lottery) -> UISetting {
        
        var uiSet = UISetting()
        
        let emptyNum = 0
        
        uiSet.numbers = [data.drwtNo1, data.drwtNo2, data.drwtNo3, data.drwtNo4 , data.drwtNo5, data.drwtNo6, emptyNum, data.bnusNo]
                
        uiSet.timesLabel = data.drwNo.formatted() + "회"
        uiSet.dateLabel = "\(data.drwNoDate) 추첨"

        
        return uiSet
    }
}
