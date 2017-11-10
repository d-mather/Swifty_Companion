//
//  SkillsViewController.swift
//  Swifty Companion
//
//  Created by Dillon MATHER on 2017/11/08.
//  Copyright © 2017 Dillon MATHER. All rights reserved.
//

import UIKit

class SkillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var skillsTable: UITableView!
    @IBOutlet weak var darkView: UIView!

    var fullName    : String = ""
    var skills      : [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skillsTable.layer.cornerRadius = 8
        darkView.layer.cornerRadius = 8
        skillsTable.estimatedRowHeight = 50
        skillsTable.rowHeight = UITableViewAutomaticDimension
        skillsTable.separatorColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        displayName.text = fullName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as! SkillsTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.skillName.text = skills[indexPath.row][0]
        cell.skillValue.text = skills[indexPath.row][1]
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.init(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
}
