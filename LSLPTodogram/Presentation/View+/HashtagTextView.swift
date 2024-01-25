//
//  HashtagTextView.swift
//  LSLPTodogram
//
//  Created by 서승우 on 2024/01/22.
//

import UIKit

final class HashtagTextView: UITextView {

    var hashtagArr: [String]?

    func resolveHashTags() {
//        self.isEditable = false
//        self.isSelectable = true

        let nsText: NSString = self.text as NSString
        let attrString = NSMutableAttributedString(string: nsText as String)
        attrString.addAttributes(
            [.font: UIFont.systemFont(ofSize: 15, weight: .regular)],
            range: NSMakeRange(0, self.text.utf16.count)
        )
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: .caseInsensitive)
        let results = hashtagDetector?.matches(
            in: self.text,
            options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds,
            range: NSMakeRange(0, self.text.utf16.count)
        )

        hashtagArr = results?.map{ (self.text as NSString).substring(with: $0.range(at: 1)) }

        if hashtagArr?.count != 0 {
            var i = 0
            for var word in hashtagArr! {
                word = "#" + word
                if word.hasPrefix("#") {
                    let matchRange:NSRange = nsText.range(
                        of: word as String,
                        options: [.caseInsensitive, .backwards]
                    )

                    attrString.addAttribute(NSAttributedString.Key.link, value: "\(i)", range: matchRange)
                    attrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15, weight: .semibold), range: matchRange)
                    i += 1
                }
            }
        }
        self.attributedText = attrString
    }

}
