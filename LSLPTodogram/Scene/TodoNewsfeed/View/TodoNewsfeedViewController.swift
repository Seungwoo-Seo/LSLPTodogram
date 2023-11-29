//
//  TodoNewsfeedViewController.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2023/11/28.
//

import UIKit

final class TodoNewsfeedViewController: BaseViewController {
    private let mainView = TodoNewsfeedMainView()

    init(_ viewModel: TodoNewsfeedViewModel) {
        super.init(nibName: nil, bundle: nil)

        let input = TodoNewsfeedViewModel.Input()
        let output = viewModel.transform(input: input)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
