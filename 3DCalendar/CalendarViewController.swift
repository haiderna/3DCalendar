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
 
    var numDaysPerMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    var weekdayData = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    var inputIndex: Int!
    let maroon = UIColor(red: 102, green: 26, blue: 77, alpha: 1.0)
    let greeny = UIColor(red: 51, green: 167, blue: 144, alpha: 1.0)
    let aqua = UIColor(red: 123, green: 229, blue: 253, alpha: 1.0)
    let lightPink = UIColor(red: 251, green: 209, blue: 223, alpha: 1.0)
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    static func make(inputIndex: Int) -> CalendarViewController {
        let viewController = UIStoryboard(name: "CalendarViewController", bundle: nil).instantiateInitialViewController() as! CalendarViewController
        viewController.inputIndex = inputIndex
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initializeView() {
        currentMonthIndex = inputIndex
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = 1
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //leap years
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numDaysPerMonth[currentMonthIndex-1] = 29
        }
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        
        setUpViews()
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let colors: [UIColor] = [.yellow, .cyan, greeny, lightPink, aqua]
        let rando = colors.randomElement()
        self.view.backgroundColor = rando
        collectionView.backgroundColor = rando
        collectionView.allowsMultipleSelection = false
        
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "Cell")
        let date = Date()
        monthLabel.text = "\(date.month(monthIndex: currentMonthIndex-1))"
    }
   
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    func setUpViews() {
//        self.view.addSubview(myCollectionView)
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        myCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView {
            return numDaysPerMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
        } else {
            return weekdayData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCell
        cell.frame.size.width = 25.0
        cell.frame.size.height = 25.0
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden = false
            cell.label.text="\(calcDate)"
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.isUserInteractionEnabled = false
                cell.label.textColor = UIColor.lightGray
            } else {
                cell.isUserInteractionEnabled = true
                cell.label.textColor = UIColor.black
            }
        }
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

class DateCell: UICollectionViewCell {
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "00"
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        let frame2 = CGRect(x: 0, y: 0, width: 25, height: 25)
        super.init(frame: frame2)
        backgroundColor = UIColor.clear
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
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    func month(monthIndex: Int) -> String {
        return Calendar.current.monthSymbols[monthIndex]
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
