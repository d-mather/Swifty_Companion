//
//  userInfo.swift
//  Swifty Companion
//
//  Created by Dillon MATHER on 2017/10/19.
//  Copyright © 2017 Dillon MATHER. All rights reserved.
//

import UIKit

class infoUser: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var darkerBackground: UIView!
    @IBOutlet weak var projectTableView: UITableView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var corr_points: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var pro_pic: UIImageView!
    @IBOutlet weak var skillLevel: UILabel!
    @IBOutlet weak var levelProgress: UIProgressView!
    @IBOutlet weak var buttonForSkillsView: UIButton!
    
    var tmp_username    : String = "Searching";
    var tmp_email       : String = "*** Please Be Patient ***";
    var tmp_corr_points : String = "00";
    var tmp_wallet      : String = "000";
    var tmp_level       : String = "00";
    var tmp_progress    : String = "00";
    var tmp_picture     : String = "";
    var tmp_full_name   : String = "";
    var tmp_projects    : [[String]] = []
    var tmp_skills      : [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set scrollview content size
        scrollView.contentSize = self.view.frame.size
        
        username.text           = tmp_username;
        email.text              = tmp_email;
        corr_points.text        = "Correction Points: " + tmp_corr_points;
        wallet.text             = "Wallet: $ " + tmp_wallet;
        levelProgress.progress  = Float(Float(tmp_progress)!/100)
        skillLevel.text         = "Skill Level : \(tmp_level) - "
        skillLevel.text         = self.skillLevel.text! + "\(tmp_progress)%"
        
        projectTableView.estimatedRowHeight = 40
        projectTableView.rowHeight = UITableViewAutomaticDimension
        self.pro_pic.layer.cornerRadius = self.pro_pic.frame.height/2
        self.username.textColor = UIColor.init(red: 66.0/255.0, green: 200.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        view.layer.masksToBounds = true
        self.darkerBackground.layer.cornerRadius = 8
        self.projectTableView.layer.cornerRadius = 8
        self.projectTableView.separatorColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        getProPic("\(tmp_picture)")
        self.projectTableView.reloadData()
    }
    
    @IBAction func returnPressedOnSearchField(_ sender: Any) {
        buttonForSkillsView.sendActions(for: .touchUpInside)
    }
    
    func getProPic(_ url_str: String)
    {
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil
            {
                let image = UIImage(data: data!)
                
                if(image != nil)
                {
                    DispatchQueue.main.async(execute: {
                        self.pro_pic.image = image
                    })
                }
            } else {
                self.createAlert(title: "Error", message: "Unfortunately the Profile picture could not be loaded")
            }
        })
        task.resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmp_projects.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "skills_view" {
            let destViewController : SkillsViewController = segue.destination as! SkillsViewController
            
            destViewController.fullName = tmp_full_name;
            destViewController.skills   = tmp_skills;
        } else if segue.identifier == "ee" {
            print("You found it!!!");
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! userInfoTableViewCell
        cell.myLabel.text = tmp_projects[indexPath.row][0] + " -> " + String(tmp_projects[indexPath.row][1] == "Pending" ? "Pending" : String(tmp_projects[indexPath.row][1] + "%"));
        
        cell.backgroundColor = UIColor.clear
        cell.myLabel.textColor = UIColor.init(red: 66.0/255.0, green: 200.0/255.0, blue: 244.0/255.0, alpha: 1.0)
//        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.init(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    /* verify a URL */
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        return UIApplication.shared.canOpenURL(url)
    }

    func createAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
