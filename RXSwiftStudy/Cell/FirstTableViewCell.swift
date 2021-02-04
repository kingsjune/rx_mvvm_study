//
//  FirstTableViewCell.swift
//  RXSwiftStudy
//
//  Created by BHJ on 2021/02/04.
//

import UIKit
import RxSwift
import RxCocoa

class FirstTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag = DisposeBag()
    
    var viewModel = ViewModel() {
        didSet {
            bind()
        }
    }
    var vc = MainViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func bind() {
        viewModel.listObservable.bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: FirstCollectionViewCell.self)){
            idx, item ,cell in
            cell.artistLabel.text = item.artistName
            cell.backgroundColor = UIColor.yellow
        }.disposed(by: disposeBag)
        
        viewModel.listObservable.subscribe { (event) in
            DispatchQueue.main.async {
                self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Results.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self!.vc.searchBar.text  = $0.artistName
            })
            .disposed(by: disposeBag)
    }
}
extension FirstTableViewCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 150, height: 150)
    }
    
}
class FirstCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var artistLabel: UILabel!
}
