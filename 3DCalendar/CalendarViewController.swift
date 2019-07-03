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

    private var viewModels = [DateCollectionViewCell.ViewModel]()
    private var dates = [Date]()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var monthLabel: UILabel!
    
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

        viewModels = dates.map {
            let isToday = Calendar.current.isDate($0, inSameDayAs: Date())
            let title = DateFormatter.singleDayDateFormatter.string(from: $0)
            let textColor: UIColor = isToday ? .black : .gray
            return DateCollectionViewCell.ViewModel(title: title,
                                                    textColor: textColor)
        }

        guard let firstDayOfMonth = dates.first, let lastDayOfMonth = dates.last else {
            return
        }
        let frontBuffer = Calendar.current.component(.weekday, from: firstDayOfMonth) - 1
        let backBuffer = 7 - Calendar.current.component(.weekday, from: lastDayOfMonth)

        (1...frontBuffer).forEach { _ in
            viewModels.insert(DateCollectionViewCell.ViewModel(title: nil, textColor: .clear), at: 0)
        }

        (1...backBuffer).forEach { _ in
            viewModels.append(DateCollectionViewCell.ViewModel(title: nil, textColor: .clear))
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
        
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        guard let firstDate = dates.first else {
            return
        }
        monthLabel.text = DateFormatter.monthDateFormatter.string(from: firstDate)
    }

    
    func setUpViews() {
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCollectionViewCell
        cell.configure(viewModel: viewModels[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 7.0,
                      height: collectionView.bounds.width / 7.0)
    }
}
