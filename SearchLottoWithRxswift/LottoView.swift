//
//  LottoView.swift
//  SearchLottoWithRxswift
//
//  Created by youngkyun park on 2/24/25.
//

import UIKit

import SnapKit

class LottoView: UIView {

    let pickerView = UIPickerView()
    var latestTimes: Int = 0
    
    lazy var inputTextField = {
        let textField = UITextField()
        textField.inputView = pickerView
        textField.textColor = .black
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        return textField
    }()
    
    let informLabel = {
        let label = UILabel()
        label.text = "당첨번호 안내"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .left
        
        return label
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        
        return label
    }()
    
    let lineView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        
        return view
    }()
    
    let timesLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .blue
        label.textAlignment = .center
        
        return label
    }()
    
    let resultLabel = {
        let label = UILabel()
        label.text = "당첨결과"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    let views = {
        var views: [UIView] = []
        
        for i in 0...7 {
            let view = UIView()
            
            DispatchQueue.main.async {
                view.layer.cornerRadius = view.frame.width / 2
            }
            
            view.backgroundColor = .black
            
            if i == 6 {
                view.backgroundColor = .clear
            }
            views.append(view)
        }
        return views
    }()
    
    let numberLabels = {
        var labels: [UILabel] = []
        
        for i in 0...7 {
            let label = UILabel()
            
            label.textColor = .white
            label.font = .systemFont(ofSize: 16)
            label.textAlignment = .center
            if i == 6 {
                label.textColor = .black
                label.text = "+"
            }
            labels.append(label)
        }
        return labels
    }()
    
    let basicButton = {
        let button = UIButton()
        button.setTitle("Basic", for: .normal)
        
        button.backgroundColor = .lightGray
        
        return button
    }()
    
    let singleButton = {
        let button = UIButton()
        button.setTitle("Single", for: .normal)
        
        button.backgroundColor = .lightGray
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        layoutView()
    }
    
    
   
    private func addView() {
        [inputTextField, informLabel, dateLabel, lineView, timesLabel, resultLabel].forEach {
            addSubview($0)
        }
        views.forEach {
            addSubview($0)
        }
        var cnt = 0
        numberLabels.forEach {
            views[cnt].addSubview($0)
            cnt += 1
        }
        [basicButton, singleButton].forEach {
            addSubview($0)
        }
        
    }
    
    
    private func layoutView() {
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(50)
        }
        
        informLabel.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(45)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(0.5)
        }
        
        timesLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(130)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.leading.equalTo(timesLabel.snp.trailing).offset(4)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        for i in 0..<views.count {
            views[i].snp.makeConstraints { make in
                make.top.equalTo(resultLabel.snp.bottom).offset(20)
                if i > 0 {
                    make.leading.equalTo(views[i-1].snp.trailing).offset(3.7)
                } else {
                    make.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
                }
                
                make.width.equalTo(45)
                make.height.equalTo(45)
            }
            
        }
        for i in 0..<numberLabels.count {
            numberLabels[i].snp.makeConstraints { make in
                make.edges.equalTo(views[i].safeAreaLayoutGuide)
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
            
        }
        
        basicButton.snp.makeConstraints { make in
            make.centerX.equalTo(self).offset(-50)
            make.centerY.equalTo(self)
        }
        
        singleButton.snp.makeConstraints { make in
            make.centerX.equalTo(self).offset(50)
            make.centerY.equalTo(self)
        }
        
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
