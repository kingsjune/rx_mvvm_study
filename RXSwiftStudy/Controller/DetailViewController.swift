//
//  DetailViewController.swift
//  RXSwiftStudy
//
//  Created by BHJ on 2021/02/04.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    private var viewModel: DetailViewModelType!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func makeViewModel(with viewModel: DetailViewModel)  {
        self.viewModel = viewModel
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bind()
    }
    
    func bind()  {
        viewModel.outputs.artistName
            .observe(on: MainScheduler.instance)
            .bind(to: artistLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.trackName
            .observe(on: MainScheduler.instance)
            .bind(to: trackLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.imgUrlStr
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .map{URL(string:$0)}
            .filter{$0 != nil}
            .map{$0!}
            .map{try Data(contentsOf: $0)}
            .map{UIImage(data: $0)}
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {img in
                self.imageView.image = img
            })
            .disposed(by: disposeBag)
    }
}

