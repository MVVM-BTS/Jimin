//
//  ViewController.swift
//  UTCTime
//
//  Created by 김지민 on 2022/08/19.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet var datetimeLabel: UILabel!

    @IBAction func onYesterday() {
        viewModel.moveDay(day: -1)
        //데이터 변경하는 거니까 뷰모델에서. 
    }

    @IBAction func onNow() {
        datetimeLabel?.text = "Loading.."
        viewModel.reload()
    }

    @IBAction func onTomorrow() {
        viewModel.moveDay(day: 1)
    }
    
    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //콜백 세팅
        viewModel.onUpdated = {[weak self] in
            
            DispatchQueue.main.async {
                self?.datetimeLabel.text = self?.viewModel.dateTimeString
            }
            //DispatchQueue.main.async 뷰모델의 didSet부분에 쓰려고 했지만, UIKit을 사용하는 이 파일에 두는 것이 더 낫다.
            viewModel.dateTimeString //변형이 일어나면
//                .observe(on: MainScheduler.instance)
//                .subscribe(onNext:{ str in//스트링이 들어오면
//                    self.datetimeLabel.text = str
//                })
//                .disposed(by: disposeBag)
                .bind(to: datetimeLabel.rx.text)
                .disposed(by: disposeBag)
        }
        viewModel.reload()//fetchNow를 하고 모델로 변형된 다음 화면으로 보이기 위한 스트링 타입으로 최종 변환까지 된다.
    }
}
