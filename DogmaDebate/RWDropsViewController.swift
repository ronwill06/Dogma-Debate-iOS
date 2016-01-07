//
//  RWDropsViewController.swift
//  DogmaDebate
//
//  Created by Rondale Williams on 1/6/16.
//  Copyright © 2016 RondaleWilliams. All rights reserved.
//

import UIKit

class RWDropsViewController: UIViewController {
    
    var dropsViewModel: RWDropsViewModel?
    var selectedIndexPath: NSIndexPath?
    var cellIsDeselected = false

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Smalley Quotes"
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationController?.navigationBar.translucent = false
        
        dropsViewModel = RWDropsViewModel()
        tableView.registerNib(UINib(nibName: "RWDropsTableViewCell", bundle: nil), forCellReuseIdentifier: "RWDropsTableViewCell")
        
    }
}

extension RWDropsViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let numberOfItems = dropsViewModel?.numberOfItems() {
            return numberOfItems
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let genericCell =  UITableViewCell()
        if let cell = tableView.dequeueReusableCellWithIdentifier("RWDropsTableViewCell", forIndexPath: indexPath) as? RWDropsTableViewCell {
            let title = dropsViewModel?.titleForIndex(indexPath.row)
            cell.titleLabel.text = title as? String
            return cell
        }
        
        return genericCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

}

extension RWDropsViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndexPath = indexPath
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if cellIsDeselected == false {
            cellIsDeselected = true
        } else {
            cellIsDeselected = false
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
