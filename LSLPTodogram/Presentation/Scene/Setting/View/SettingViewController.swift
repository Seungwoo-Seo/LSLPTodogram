//
//  SettingViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/21.
//

import UIKit
import RxCocoa
import RxSwift

final class SettingViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let mainView = SettingMainView()

    private let viewMdoel: SettingViewModel = SettingViewModel()

    init() {
        super.init(nibName: nil, bundle: nil)


        let input = SettingViewModel.Input(
            modelSelected: mainView.tableView.rx.modelSelected(String.self)
        )
        let output = viewMdoel.transform(input: input)

        output.items
            .drive(mainView.tableView.rx.items(cellIdentifier: "Cell")) { row, item, cell in
                cell.textLabel?.text = item
            }
            .disposed(by: disposeBag)

        output.windowResetTrigger
            .bind(with: self) { owner, _ in
                owner.windowReset()
            }
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    override func initialAttributes() {
        super.initialAttributes()

        navigationController?.navigationBar.tintColor = Color.black
        navigationItem.title = "설정"
    }

}
