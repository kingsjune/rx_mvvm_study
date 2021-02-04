//
//  SecondTableViewCell.swift
//  RXSwiftStudy
//
//  Created by BHJ on 2021/02/04.
//
import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class SecondTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag = DisposeBag()
    var viewModel = ViewModel() {
        didSet {
            bind()
        }
    }
    var vc  = MainViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind() {
        viewModel.listObservable.bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: SecondCollectionViewCell.self))
        {
            idx, item ,cell in
            cell.artistLabel.text = item.artistName
            cell.trackLabel.text = item.trackName
            cell.thumImgView.sd_setImage(with: URL(string: item.artworkUrl100), completed: nil)
            cell.backgroundColor = UIColor.systemPink
        }
        .disposed(by: disposeBag)
        
        viewModel.listObservable.subscribe { (event) in
            DispatchQueue.main.async {
                self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Results.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let dvc = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController else{
                    return
                }
                dvc.makeViewModel(with: DetailViewModel(res: $0))
                self!.vc.present(dvc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension SecondTableViewCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 214 , height: 146)
    }
}

class SecondCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumImgView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
}

