//
//  CalendarViewController.swift
//  bolt
//
//  Created by Najia Haider on 2/20/19.
//  Copyright © 2019 Najia Haider. All rights reserved.
//

import UIKit
//Calendar View Controller based off of https://github.com/jahid-hasan-polash/Calendar-iOS
class CalendarViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {


    var dates = [Date]()

    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    static func make(date: Date) -> CalendarViewController {
        let viewController = UIStoryboard(name: "CalendarViewController", bundle: nil).instantiateInitialViewController() as! CalendarViewController
        viewController.setupDates(firstDayOfMonth: date)
        return viewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        initializeView()
    }

    private func setupDates(firstDayOfMonth: Date) {
        let range = Calendar.current.range(of: .day, in: .month, for: firstDayOfMonth)!
        let currentDate = Calendar.current.dateComponents([.year, .month],
                                                          from: firstDayOfMonth)
        dates = range.compactMap {
            return DateComponents(calendar: .current,
                                  timeZone: .current,
                                  year: currentDate.year,
                                  month: currentDate.month,
                                  day: $0).date
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initializeView() {
        setUpViews()
        setUpCollectionView()
        
    }
    
    func setUpCollectionView() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let colors: [UIColor] = [.yellow, .cyan, .white, .green]
        let rando = colors.randomElement()
        self.view.backgroundColor = rando
        collectionView.backgroundColor = rando
        collectionView.allowsMultipleSelection = false
        
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "Cell")

        guard let firstDate = dates.first else {
            return
        }
        monthLabel.text = DateFormatter.monthDateFormatter.string(from: firstDate)
    }

    
    func setUpViews() {
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCell
        configure(cell: cell, indexPath: indexPath)
        return cell
        
    }

    private func configure(cell: DateCell, indexPath: IndexPath) {
        let currentDate = dates[indexPath.row]

        cell.label.text = DateFormatter.singleDayDateFormatter.string(from: currentDate)

        if Calendar.current.isDate(currentDate, inSameDayAs: Date()) {
            cell.label.textColor = .black
        } else {
            cell.label.textColor = .lightGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 7.0,
                      height: collectionView.bounds.width / 7.0)
    }
}
