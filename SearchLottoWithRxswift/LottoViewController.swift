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
        
        let input = LottoViewModel.Input(viewDidLoad: Observable.just(()))
        let output = viewModel.transform(input: input)
        

        output.numbers.asDriver(onErrorJustReturn: []).drive(lottoView.pickerView.rx.itemTitles) { (row, element) in
            
            return String(element)
            
        }.disposed(by: disposeBag)
        

        
        lottoView.pickerView.rx.itemSelected.subscribe(with: self) { owner, value in
            print(value.0) //row
            print(value.1) //component
            
        }.disposed(by: disposeBag)
            

    }
    


}
