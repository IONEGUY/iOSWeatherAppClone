//
//  FixedHeaderTableView.swift
//  iOSWeatherAppClone
//
//  Created by MacBook on 9/8/20.
//  Copyright © 2020 Ivan Zavadsky. All rights reserved.
//

import UIKit

class FixedHeaderTableView: UITableView {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var weatherTopConstraint: NSLayoutConstraint! {
        didSet {
            weatherTopConstraintValue = weatherTopConstraint.constant
        }
    }
    @IBOutlet weak var hidingContainer: UIView!
    
    private let devider: CGFloat = 7.5
    private let minHeightOffset: CGFloat = -270
    private let maxAlphaValue: CGFloat = 100
    private var weatherTopConstraintValue: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let header = tableHeaderView else { return }
        let offsetY = -contentOffset.y
        
        if offsetY <= minHeightOffset + safeAreaInsets.top {
            bottomConstraint?.isActive = false
            topConstraint.constant = contentOffset.y
        } else {
            if offsetY <= safeAreaInsets.top {
                hidingContainer.alpha = (maxAlphaValue - abs(offsetY - safeAreaInsets.top)) / maxAlphaValue
                weatherTopConstraint.constant = weatherTopConstraintValue + offsetY / devider
            }
            topConstraint.constant = contentOffset.y
            heightConstraint.constant = header.bounds.height - contentOffset.y
        }
    }
}
