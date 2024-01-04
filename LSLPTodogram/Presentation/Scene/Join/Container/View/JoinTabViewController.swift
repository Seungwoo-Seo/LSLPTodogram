//
//  JoinTabViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/25.
//

import UIKit
import RxCocoa
import RxSwift
import Pageboy
import Tabman

final class JoinTabViewController: BaseTabmanViewController {
    private let disposeBag = DisposeBag()

    private lazy var backButtonItem = {
        let view = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButtonItem)
        )
        return view
    }()
    private let lineBar = {
        let view = TMBar.LineBar()
        view.indicator.weight = .light
        view.backgroundView.style = .flat(color: .secondarySystemBackground)
        view.indicator.tintColor = Color.red
        return view
    }()

    private let viewModel: JoinViewModel

    init(viewModel: JoinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let input = JoinViewModel.Input()
        let output = viewModel.transform(input: input)
        output.scrollToPassword
            .bind(with: self) { owner, _ in
                owner.scrollToPage(.next, animated: true)
            }
            .disposed(by: disposeBag)

        output.scrollToUserDetail
            .bind(with: self) { owner, _ in
                owner.scrollToPage(.next, animated: true)
            }
            .disposed(by: disposeBag)

        output.backScrollToEmail
            .bind(with: self) { owner, _ in
                owner.scrollToPage(.previous, animated: true)
            }
            .disposed(by: disposeBag)

        output.backScrollToPassword
            .bind(with: self) { owner, _ in
                owner.scrollToPage(.previous, animated: true)
            }
            .disposed(by: disposeBag)

        output.popToRoot
            .bind(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func initialAttributes() {
        super.initialAttributes()

        navigationItem.title = "회원가입"
        dataSource = self
        isScrollEnabled = false
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        navigationItem.leftBarButtonItem = backButtonItem
        addBar(lineBar, dataSource: self, at: .top)
    }

}

extension JoinTabViewController: PageboyViewControllerDataSource {

    func numberOfViewControllers(
        in pageboyViewController: Pageboy.PageboyViewController
    ) -> Int {
        return viewModel.numberOfViewControllers
    }

    func viewController(
        for pageboyViewController: Pageboy.PageboyViewController,
        at index: Pageboy.PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewModel.viewController(at: index)
    }

    func defaultPage(
        for pageboyViewController: Pageboy.PageboyViewController
    ) -> Pageboy.PageboyViewController.Page? {
        return nil
    }

}

extension JoinTabViewController: TMBarDataSource {

    func barItem(
        for bar: Tabman.TMBar,
        at index: Int
    ) -> Tabman.TMBarItemable {
        return TMBarItem(title: "")
    }

}

private extension JoinTabViewController {

    @objc
    func didTapBackButtonItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "로그인 화면으로 돌아가면 작성했던 모든 내용이 사라집니다. 그래도 돌아가시겠습니까?",
            message: nil,
            preferredStyle: .alert
        )
        let no = UIAlertAction(title: "아니오", style: .cancel)
        let yes = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let self else {return}
            self.navigationController?.popViewController(animated: true)
        }
        [no, yes].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

}
