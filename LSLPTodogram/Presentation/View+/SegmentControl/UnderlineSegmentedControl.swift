//
//  UnderlineSegmentedControl.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/08.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {

    private lazy var underlineView: UIView = {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let height = 2.0
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
        let yPosition = self.bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = Color.black
        self.addSubview(view)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBackgroundAndDivider()
    }

    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBackgroundAndDivider()
        setTitleTextAttributes([.foregroundColor: Color.black], for: .normal)
        setTitleTextAttributes(
            [
                .foregroundColor: Color.black,
                .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
            ],
            for: .selected
        )
        selectedSegmentIndex = 0
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.underlineView.frame.origin.x = underlineFinalXPosition
            }
        )
    }

    private func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)

        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}
