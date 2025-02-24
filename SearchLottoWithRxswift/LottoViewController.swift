//
//  LottoViewController.swift
//  SearchLottoWithRxswift
//
//  Created by youngkyun park on 2/24/25.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class LottoViewController: UIViewController {

    
    private let lottoView = LottoView()
    private let viewModel = LottoViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = lottoView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.rx.tapGesture().bind(with: self) { owner, _ in
            owner.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        bind()
    }
    
    
    private func bind() {
        
        let input = LottoViewModel.Input(viewDidLoad: Observable.just(()),
                                         basicButtonTapped: lottoView.basicButton.rx.tap.withLatestFrom(lottoView.pickerView.rx.itemSelected),
                                         singleButtonTapped: lottoView.singleButton.rx.tap.withLatestFrom(lottoView.pickerView.rx.itemSelected))
                                         
        let output = viewModel.transform(input: input)
        
        output.numbers.asDriver(onErrorJustReturn: []).drive(lottoView.pickerView.rx.itemTitles) { (row, element) in
            
            return String(element)
            
        }.disposed(by: disposeBag)
        

        output.settingView.asDriver()
            .drive(with: self) { owner, value in
                                
                
                owner.lottoView.timesLabel.text = value.timesLabel
                owner.lottoView.dateLabel.text = value.dateLabel
                owner.lottoView.inputTextField.text = value.inputTextField
                
                for i in 0..<value.numbers.count {
                    
                    if i == 6 {
                        continue
                    }
                    
                    switch value.numbers[i] {
                    case 0...10:
                        owner.lottoView.views[i].backgroundColor = #colorLiteral(red: 0.9825044274, green: 0.768058002, blue: 0, alpha: 1)
                    case 11...20:
                        owner.lottoView.views[i].backgroundColor = #colorLiteral(red: 0.4083472788, green: 0.7813892961, blue: 0.9461943507, alpha: 1)
                    case 21...30:
                        owner.lottoView.views[i].backgroundColor = #colorLiteral(red: 0.9968531728, green: 0.4501410723, blue: 0.4451909661, alpha: 1)
                    case 31...40:
                        owner.lottoView.views[i].backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                    case 41...45:
                        owner.lottoView.views[i].backgroundColor = #colorLiteral(red: 0.6902902126, green: 0.8477550149, blue: 0.2529574037, alpha: 1)
                    default:
                        print("범위에서 벗어났습니다.")
                    }
                    owner.lottoView.numberLabels[i].text = "\(value.numbers[i])"
                }
                
            }.disposed(by: disposeBag)
        
    
            

    }
    


}
