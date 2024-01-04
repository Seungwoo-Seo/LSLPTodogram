//
//  BupInputViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/30.
//

import UIKit
import PhotosUI
import RxCocoa
import RxSwift

final class BupInputViewController: BaseViewController {
    private var disposeBag = DisposeBag()

    // MARK: - View
    private let cancelBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "취소"
        barButtonItem.style = .plain
        return barButtonItem
    }()
    private let postingButton = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "게시"
        barButtonItem.style = .plain
        return barButtonItem
    }()
    fileprivate let mainView = BupInputMainView()

    // MARK: - ViewModel
    fileprivate let viewModel: BupInputViewModel

    // MARK: - init
    init(_ viewModel: BupInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        let input = BupInputViewModel.Input(
            cancelBarButtonItemTapped: cancelBarButtonItem.rx.tap,
            postingButtonTapped: postingButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        output.items
            .bind(to: mainView.tableView.rx.items) { (tableView, row, item) in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: BupInputCell.identifier
                ) as? BupInputCell else {return UITableViewCell()}

                cell.configure(item)
                cell.bind(viewModel.bupInputCellViewModel)

                return cell
            }
            .disposed(by: disposeBag)

        output.isModalInPresentState
            .bind(to: rx.isModalInPresentation)
            .disposed(by: disposeBag)

        output.unwindState
            .bind(to: rx.unwind)
            .disposed(by: disposeBag)

        output.imageButtonTapped
            .emit(to: rx.presentPicker)
            .disposed(by: disposeBag)

        output.imagesUpdated
            .emit(to: rx.tableViewUpdate)
            .disposed(by: disposeBag)


//        output.postingDone
//            .bind(with: self) { owner, _ in
//                owner.unwind()
//            }
//            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func initialAttributes() {
        super.initialAttributes()

        navigationController?.navigationBar.tintColor = Color.white
        navigationItem.title = "새로운 Bup"
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = postingButton
    }

}

extension BupInputViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        viewModel.imageResults.accept(results)
    }

}

private extension Reactive where Base: BupInputViewController {

    var presentPicker: Binder<Void> {
        return Binder(base) { (vc, _) in
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 5
            config.selection = .ordered
            config.filter = .images
            config.preferredAssetRepresentationMode = .current
            config.preselectedAssetIdentifiers = vc.viewModel.selectedAssetIdentifiers
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = vc
            picker.title = "최대 5개의 항목을 선택합니다."
            vc.present(picker, animated: true)
        }
    }

    var tableViewUpdate: Binder<Void> {
        return Binder(base) { (vc, _) in
            UIView.setAnimationsEnabled(false)
            vc.mainView.tableView.performBatchUpdates(nil)
            UIView.setAnimationsEnabled(true)
        }
    }

    var unwind: Binder<Bool> {
        return Binder(base) { (vc, bool) in
            if bool {
                vc.dismiss(animated: true)
            } else {
                let alert = UIAlertController(
                    title: "답글을 삭제하시겠어요?",
                    message: nil,
                    preferredStyle: .alert
                )

                let cancel = UIAlertAction(title: "취소", style: .cancel)
                let remove = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    vc.dismiss(animated: true)
                }
                [cancel, remove].forEach { alert.addAction($0) }

                vc.present(alert, animated: true)
            }
        }
    }

}
