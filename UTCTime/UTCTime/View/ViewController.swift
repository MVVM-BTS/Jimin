//
//  ViewController.swift
//  UTCTime
//
//  Created by 김지민 on 2022/08/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var datetimeLabel: UILabel!

    @IBAction func onYesterday() {

    }

    @IBAction func onNow() {
    }

    @IBAction func onTomorrow() {

    }
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()//fetchNow를 하고 모델로 변형된 다음 화면으로 보이기 위한 스트링 타입으로 최종 변환까지 된다.
        datetimeLabel.text = viewModel.dateTimeString //변경된 값 화면에 적용
    }
}
