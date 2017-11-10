//
//  ViewController.swift
//  Swifty Companion
//
//  Created by Dillon MATHER on 2017/10/17.
//  Copyright © 2017 Dillon MATHER. All rights reserved.
//  ;

import UIKit
import ft_api_pod
import Alamofire
import Foundation

class ViewController: UIViewController, UserControlDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var darkerBackground: UIView!
    @IBOutlet weak var pleaseWait: UILabel!
    
    
    /* Segue Properties */
    var pass            : Int = 0;
    var access_count    : Int = 0;
    var access_pass     : Int = 10;
    var login           : String = "";
    var email           : String = "";
    var corr_pnts       : String = "";
    var wallet          : String = "";
    var level           : String = "";
    var progress        : String = "";
    var picture         : String = "";
    var full_name       : String = "";
    var projects        : [[String]] = [];
    var skills          : [[String]] = [];
    
    var ft_api_pod_request : APIController?;

    override func viewDidLoad() {
        super.viewDidLoad()
        ft_api_pod_request = APIController(delegate: self);
        self.searchField.layer.borderColor = UIColor(red: 30/255, green: 185/255, blue: 187/255, alpha: 1).cgColor
        self.searchField.layer.borderWidth = CGFloat(Float(1.0))
        self.searchField.layer.cornerRadius = CGFloat(Float(3.0))
        self.searchButton.layer.cornerRadius = CGFloat(Float(5.0))
        view.layer.masksToBounds = true
        self.darkerBackground.layer.cornerRadius = 8
        self.searchField.becomeFirstResponder()
        self.pleaseWait.isHidden = true
    }

    @IBAction func returnPressedOnSearchField(_ sender: Any) {
        searchButton.sendActions(for: .touchUpInside)
    }

    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if identifier == "infoUser" {
            self.searchButton.setTitle("Searching", for: .normal)
            self.pleaseWait.isHidden = false
            if (sender as? String) != nil {
                if sender as! String == "1" {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "infoUser" {
            let destViewController : infoUser = segue.destination as! infoUser
            
            if (sender as? String) != nil {
                if sender as! String == "1" {
                    destViewController.tmp_username     = login;
                    destViewController.tmp_email        = email;
                    destViewController.tmp_corr_points  = corr_pnts;
                    destViewController.tmp_wallet       = wallet;
                    destViewController.tmp_level        = level;
                    destViewController.tmp_progress     = progress;
                    destViewController.tmp_picture      = picture;
                    destViewController.tmp_projects     = projects;
                    destViewController.tmp_full_name    = full_name;
                    destViewController.tmp_skills       = skills;
                    
                    self.searchButton.setTitle("Search", for: .normal)
                    self.pleaseWait.isHidden = true
                    
                    self.pass = 0;
                    self.access_count = 0;
                    self.access_pass = 10;
                    self.login = "";
                    self.email = "";
                    self.corr_pnts = "";
                    self.wallet = "";
                    self.level = "";
                    self.progress = "";
                    self.picture = "";
                    self.full_name = "";
                    self.projects = [];
                    self.skills = [];
                }
            }
        } else if segue.identifier == "ee" {
            print("You found it!!!");
        }
        self.searchButton.setTitle("Search", for: .normal)
        self.pleaseWait.isHidden = true
    }
    
    @IBAction func SearchButton(_ sender: UIButton) {
        if self.searchField.text == "" {
            createAlert(title: "Error", message: "Please enter a username");
        } else {
            var tmp = self.searchField.text?.components(separatedBy: " ")
            ft_api_pod_request?.getUserData((tmp?[0])!);
        }
    }
    
    /* verify a URL */
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }

    /* alert func */
    func createAlert (title:String, message:String) {
        if title == "User Error" {
            _ = navigationController?.popToRootViewController(animated: true)
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        self.searchButton.setTitle("Search", for: .normal)
        self.pleaseWait.isHidden = true
    }
    
    /* link to profile pictures */
    func ft_picture (_picture_url_ : String) {
        var pic = _picture_url_
        if pic.range(of:"default") != nil {
            pic = pic.replacingOccurrences(of: "default", with: "large_" + self.searchField.text!, options: .literal, range: nil)
            pic = pic.replacingOccurrences(of: "images", with: "users", options: .literal, range: nil)
            pic = pic.replacingOccurrences(of: "png", with: "jpg", options: .literal, range: nil)
        }
        if verifyUrl(urlString: pic) {
            picture = pic;
        } else {
            var newPicURL = pic.replacingOccurrences(of: "large_", with: "medium_" + self.searchField.text!, options: .literal, range: nil)
            if verifyUrl(urlString: newPicURL) {
                picture = newPicURL;
            } else {
                newPicURL = pic.replacingOccurrences(of: "large_", with: "small_" + self.searchField.text!, options: .literal, range: nil)
                if verifyUrl(urlString: newPicURL) {
                    picture = newPicURL;
                } else {
                    picture = "http://cdn.pcwallart.com/images/lions-roaring-wallpaper-4.jpg"
                }
            }
        }
        access_count += 1;
        
        if (access_count == access_pass) {
            self.performSegue(withIdentifier: "infoUser", sender: "1");
        }
    }
    
    /* login */
    func ft_login (_login_ : String) {
        login = _login_;
        access_count += 1;
        
        if (access_count == access_pass) {
            self.performSegue(withIdentifier: "infoUser", sender: "1");
        }
    }
    
    /* email */
    func ft_email (_email_ : String) {
        email = _email_;
        access_count += 1;
        
        if (access_count == access_pass) {
            self.performSegue(withIdentifier: "infoUser", sender: "1");
        }
    }
    
    /* wallet */
    func ft_wallet (_wallet_ : String) {
        wallet = _wallet_;
        access_count += 1;
        
        if (access_count == access_pass) {
            self.performSegue(withIdentifier: "infoUser", sender: "1");
        }
    }
    
    /* correction points */
    func ft_correction_points (_correction_points_ : String) {
        corr_pnts = _correction_points_;
        access_count += 1;
        
        if (access_count == access_pass) {
            self.performSegue(withIdentifier: "infoUser", sender: "1");
        }
    }
    
    /* level + progress */
    func ft_level (_level_ : String) {
        var sep     = _level_.components(separatedBy: ".")
        if (sep[0]).isEmpty {
            level       = "00"
        } else {
            level       = sep[0]
        }
        if sep.indices.contains(1) {
            progress    = sep[1]
        } else {
            progress    = "0"
        }

        access_count += 2;
        
        if (access_count == access_pass) {
            self.performSegue(withIdentifier: "infoUser", sender: "1");
        }
    }
    
    /* display name */
    func ft_display_name (_display_name_ : String) {
        full_name = _display_name_;
        access_count += 1;
        
        if (access_count == access_pass) {
            self.performSegue(withIdentifier: "infoUser", sender: "1");
        }
    }
    
    /* skills with level and percentage */
    func ft_skills (_skills_ : [[String : Any]]) {
        var name : String?
        var level : String?
        for jsonData_cursus in _skills_ {
            for jsonData_cursus_L1 in jsonData_cursus {
                switch jsonData_cursus_L1.key {
                case "name":
                    name = "\(jsonData_cursus_L1.value)";
                case "level":
                    level = "\(jsonData_cursus_L1.value)";
                default:
                    break ;
                }
            }
            if (name != nil && level != nil) {
                skills.append([name!, level!]);
            }
        }
        access_count += 1;
        
        if (access_count == access_pass) {
            self.performSegue(withIdentifier: "infoUser", sender: "1");
        }
    }
    
    /* all projects but bootcamps */
    func ft_projects(_project_ : [(String, String, String, String)]) {
        var ii = 0
        
        if self.projects.isEmpty {
            ii = 1
        } else {
            ii = 0
        }
        for project_details in _project_ {
            if project_details.0 == "" {
                continue;
            }
            if ii == 0 {
                break;
            } else if ii == 1 {
//                print("Validated: \(project_details)")
                projects.append([project_details.0, (project_details.1 == "<null>" ? "Pending" : project_details.1)])
            }
        }
        
        
        if (access_count == access_pass - 1) && pass == 0 {
            pass = 1;
            self.performSegue(withIdentifier: "infoUser", sender: "1");
        }
    }
    
    
    /* Errors */
    func  ft_error(_type_ : String, _message_ : String) {
        createAlert(title: "\(_type_)", message: "\(_message_)");
        print ("{-} [\(_type_)] :: \(_message_)!!!");
        self.searchButton.setTitle("Search", for: .normal)
        self.pleaseWait.isHidden = true
    }

}
