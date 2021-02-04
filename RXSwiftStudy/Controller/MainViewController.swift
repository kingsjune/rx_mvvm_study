//
//  MainViewController.swift
//  RXSwiftStudy
//
//  Created by BHJ on 2021/02/04.
//

import UIKit

import UIKit
import RxSwift
import RxCocoa
class MainViewController: UIViewController{

    var viewModel = ViewModel()
    var disposeBag = DisposeBag()
    var searchStr = String()
    var country1Str = String()
    var country2Str = String()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var country01Field: UITextField!
    @IBOutlet weak var country02Field: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }

    func bind()  {
        //Input
        searchBar.rx.text
            .filter{$0 != nil}
            .map{$0!}
            .subscribe(onNext: { searchStr in
                self.searchStr = searchStr
            })
            .disposed(by: disposeBag)
        
        country01Field.rx.text
            .filter{$0 != nil}
            .map{$0!}
            .subscribe (onNext: { country01 in
                self.country1Str = country01
            })
            .disposed(by: disposeBag)
        
        country02Field.rx.text
            .filter{$0 != nil}
            .map{$0!}
            .subscribe (onNext: { country02 in
                self.country2Str  = country02
            })
            .disposed(by: disposeBag)
        
        
        searchButton.rx.tap
            .bind(onNext: {
                self.viewModel.callAPI(searchStr : self.searchStr, contry1Str : self.country1Str , contry2Str : self.country2Str)
            })
            .disposed(by: disposeBag)
       
        //output
        // 에러 처리
        viewModel.outputs.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let ac = UIAlertController(title: "Error\($0)", message: "에러입니다.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(ac, animated: true)
            })
            .disposed(by: disposeBag)
    }

}

extension MainViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Holizontal Scroll Area"
        }
        return "Vertical Scroll Area"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell  = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as? FirstTableViewCell else{
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            cell.vc = self
            return cell
        }
        else {
            guard let cell  = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as? SecondTableViewCell else{
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            cell.vc  = self
            return cell
        }
    }
    
}
