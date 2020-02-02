//
//  ViewController.swift
//  ChenCodeRxSwiftFilteringOperators
//
//  Created by Chen Codes on 1/31/20.
//  Copyright © 2020 Chen Codes. All rights reserved.
//

import AnchorKit
import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButtonListeners()
        setupSubjectListener()
    }
    
    private func setupViews() {
        view.addSubview(textField)
        view.addSubview(nextButton)
        view.addSubview(completeButton)
        view.addSubview(errorButton)
        view.addSubview(resetButton)
        textField.constrain(.centerX, to: view)
        nextButton.constrain(.centerX, to: view)
        completeButton.constrain(.centerX, to: view)
        errorButton.constrain(.centerX, to: view)
        resetButton.constrain(.centerX, to: view)
        textField.constrain(.top, to: view).inset(200)
        nextButton.constrain(.top, to: .bottom, of: textField).inset(Constant.spacing)
        completeButton.constrain(.top, to: .bottom, of: nextButton).inset(Constant.spacing)
        errorButton.constrain(.top, to: .bottom, of: completeButton).inset(Constant.spacing)
        resetButton.constrain(.top, to: .bottom, of: errorButton).inset(Constant.spacing)
    }
    
    private func setupButtonListeners() {
        nextButton.rx.tap.subscribe { [weak self] _ in
            self?.subject.onNext(self?.textField.text ?? "nil")
        }.disposed(by: disposeBag)
        
        completeButton.rx.tap.subscribe { [weak self] _ in
            self?.subject.onCompleted()
        }.disposed(by: disposeBag)
        
        errorButton.rx.tap.subscribe { [weak self] _ in
            self?.subject.onError(SomeError.Error)
        }.disposed(by: disposeBag)
        
        resetButton.rx.tap.subscribe { [weak self] _ in
            self?.subject = .init()
            self?.setupSubjectListener()
            print("reset")
        }.disposed(by: disposeBag)
    }
    
    private func setupSubjectListener() {
        subject
            // Insert operator below
            .subscribe(onNext: { text in
            print("onNext(\(text))")
        }, onError: { error in
            print("error")
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
            .disposed(by: disposeBag)
    }
    
    private var subject: PublishSubject<String> = .init()
    private let disposeBag: DisposeBag = .init()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.constrain(to: .init(width: Constant.width,
                                      height: Constant.height))
        textField.placeholder = "Insert value"
        textField.textAlignment = .center
        return textField
    }()
    
    private let nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.backgroundColor = .green
        nextButton.setTitle("onNext", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.constrain(to: .init(width: Constant.width,
                                       height: Constant.height))
        return nextButton
    }()
    
    private let completeButton: UIButton = {
        let completeButton = UIButton()
        completeButton.backgroundColor = .yellow
        completeButton.setTitle("onCompleted", for: .normal)
        completeButton.setTitleColor(.black, for: .normal)
        completeButton.constrain(to: .init(width: Constant.width,
                                           height: Constant.height))
        return completeButton
    }()
    
    private let errorButton: UIButton = {
        let errorButton = UIButton()
        errorButton.backgroundColor = .red
        errorButton.setTitle("onError", for: .normal)
        errorButton.setTitleColor(.black, for: .normal)
        errorButton.constrain(to: .init(width: Constant.width,
                                        height: Constant.height))
        return errorButton
    }()
    
    private let resetButton: UIButton = {
        let resetButton = UIButton()
        resetButton.backgroundColor = .blue
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.constrain(to: .init(width: Constant.width,
                                        height: Constant.height))
        return resetButton
    }()
    
    private enum Constant {
        static let height: CGFloat = 75
        static let spacing: CGFloat = 50
        static let width: CGFloat = 250
    }
    
    private enum SomeError: Error {
        case Error
    }
}

