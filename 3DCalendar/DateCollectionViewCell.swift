//
//  DateCell.swift
//  3DCalendar
//
//  Created by Najia Haider on 7/2/19.
//  Copyright © 2019 Najia Haider. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {

    struct ViewModel {
        let title: String?
        let textColor: UIColor
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        let updatedFrame = CGRect(x: 0, y: 0, width: 25, height: 25)
        super.init(frame: updatedFrame)
        backgroundColor = .clear
        layer.cornerRadius = 5
        layer.masksToBounds = true
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func configure(viewModel: ViewModel) {
        label.text = viewModel.title
        label.textColor = viewModel.textColor
    }
}
