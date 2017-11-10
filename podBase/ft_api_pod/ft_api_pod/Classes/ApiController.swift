//
//  ApiController.swift
//  Pods
//
//  Created by Dillon Mather on 2017/10/18.
//

import UIKit
import Alamofire
import SwiftyJSON

public class APIController {
    
    /* Authentification Properties */
    var UID = "bdd2969d0a659be75ab29be064613798310ce1c43454ad565e351f3edf68fc98"
    var SECRET = "261ffddfe33c070eb95a62b5971de750ebd69cec235dd54f10f947e36cdc6033"
//    var UID = "c1fd50f5307152502596ea279975433db80b4b59b3c7f9e4bb88364bef39d621"
//    var SECRET = "5911eb07405f829f3dda9057c1dbb554e807397ae1694a3783423b4412ff0f08"
    var token           : String?
    var TheUserLogin    : String = "-";
    var TheUserID       : String?;
    
    /* Link to View Conrtoller */
    var delegate: UserControlDelegate?
    
    /* Class Initializer */
    public init(delegate: UserControlDelegate) {
        self.delegate = delegate;
        self.getToken();
    }
    
    /* Get 42 API Token Token (OAUTH) */
    func getToken() {
        let tokenURL: URL = URL(string: "https://api.intra.42.fr/oauth/token")!
        
        let tokenParamater: Parameters = [
            "grant_type" : "client_credentials",
            "client_id" : UID,
            "client_secret" : SECRET
        ]
        
        Alamofire.request(tokenURL, method: .post, parameters: tokenParamater).responseJSON(completionHandler: {
            response in
            let json = JSON(data: response.data!)
            self.token = json["access_token"].string
        })
    }
    
    public func getUserData(_ login: String) {
        self.TheUserLogin       = login;
        let IdURL = URL(string: "https://api.intra.42.fr/v2/users?filter[login]=\(login.lowercased())")!
        var IdRequest = URLRequest(url: IdURL);
        
        /* Check If Token Was Generated */
        if (self.token == nil || self.token == "") {
            self.delegate?.ft_error(_type_: "Error : 42apiSlowResponse", _message_: "Invalid username OR Internet Connection To France Is Too Weak")
            return ;
        }
        
        do{
            IdRequest.addValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization");
        }
        
        Alamofire.request(IdRequest).responseJSON(completionHandler: {
            response in
            
            let json = JSON(response.data!).array;
            
            /* Check If User Exists */
            if (json?.first?["id"] == nil) {
                print ("Conexion time out for user -> \(login)...");
                self.delegate?.ft_error(_type_: "Error", _message_: "Invalid username OR Connection timed out")
                return ;
            }
            
            /* Get And Set User ID */
            let userID = (json?.first?["id"].int!)!;
            self.TheUserID = "\(userID)";
            
            /* Creating Request URLs  */
            let DataURL = URL(string: "https://api.intra.42.fr/v2/users/\(String(userID))")!;
            
            self.ft_apiRequest(_dataRequest_ : URLRequest(url: DataURL));
        })
    }
    
    func ft_apiRequest (_dataRequest_ : URLRequest) {
        var dataRequest : URLRequest = _dataRequest_;
        do{
            dataRequest.addValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization");
        }
        
        /* Get JSON For Basic Personal Data */
        Alamofire.request(dataRequest).responseJSON(completionHandler: {
            response in
            
            let json = JSON(response.data!).dictionaryObject;
            
            if (json == nil) {
                print ("{-}Error :: unexpected network failure!")
                return ;
            }
            self.ft_setBasicUserDetails(_json_ : json!);
        })
        
    }
    
    func ft_setBasicUserDetails (_json_ : [String : Any], _WeThinkCode_ : Bool = true){
        if (self.TheUserID != nil) {
            
            /* Logical Properies */
            var isWeThinkCode_  : CShort = 0;
            var skills_access   : Bool = false;
            var level_access    : Bool = false;
            
            var projects_details   : [(String, String, String, String)] = [("", "", "", "")];
            
            for jsonData_L1 in _json_ {
                switch jsonData_L1.key {
                case "login":
                    self.delegate?.ft_login(_login_: "\(jsonData_L1.value)");
                case "email":
                    self.delegate?.ft_email(_email_: "\(jsonData_L1.value)");
                case "wallet":
                    self.delegate?.ft_wallet(_wallet_: "\(jsonData_L1.value)");
                case "image_url":
                    let user_image_url : String = "\(jsonData_L1.value)";
                    self.delegate?.ft_picture(_picture_url_ : user_image_url);
                case "correction_point":
                    self.delegate?.ft_correction_points(_correction_points_: "\(jsonData_L1.value)");
                case "displayname":
                    if (jsonData_L1.key == "displayname") {
                        self.delegate?.ft_display_name(_display_name_: "\(jsonData_L1.value)");
                    }
                case "cursus_users":
                    var tlevel  : String?;
                    var tskills : [[String : Any]]?;
                    for jsonData_L2 in jsonData_L1.value as! NSArray {
                        for jsonData_L3 in jsonData_L2 as! [String : Any]{
                            if (jsonData_L3.key == "level") {
                                tlevel  = "\(jsonData_L3.value)";
                                if (isWeThinkCode_ == 1 && _WeThinkCode_ && level_access) {
                                    self.delegate?.ft_level(_level_: tlevel!);
                                }
                                else if (isWeThinkCode_ == 2 && !_WeThinkCode_ && level_access) {
                                    self.delegate?.ft_level(_level_: tlevel!);
                                }
                                else if (isWeThinkCode_ == 3 && !_WeThinkCode_ && level_access) {
                                    self.delegate?.ft_level(_level_: tlevel!);
                                }
                            }
                            if (jsonData_L3.key == "skills") {
                                tskills = jsonData_L3.value as? [[String : Any]];
                                if (isWeThinkCode_ == 1 && _WeThinkCode_ && skills_access) {
                                    self.delegate?.ft_skills(_skills_: tskills!);
                                }
                                else if (isWeThinkCode_ == 2 && !_WeThinkCode_ && skills_access) {
                                    self.delegate?.ft_skills(_skills_: tskills!);
                                }
                            }
                            if (jsonData_L3.key == "cursus") {
                                for jsonData_cursus in (jsonData_L3.value as? [String : Any])! {
                                    if (jsonData_cursus.key == "slug") {
                                        if ("\(jsonData_cursus.value)" != "wethinkcode_" && "\(jsonData_cursus.value)" != "bootcamp") {
                                            print("This User Is Not At WeThinkCode!");
                                            self.delegate?.ft_correction_points(_correction_points_: "-");
                                            self.delegate?.ft_display_name(_display_name_: "-");
                                            self.delegate?.ft_level(_level_: "-");
                                            self.delegate?.ft_email(_email_: "-");
                                            self.delegate?.ft_login(_login_: "-");
                                            self.delegate?.ft_picture(_picture_url_: "-");
                                            self.delegate?.ft_projects(_project_: [("-", "-", "-", "-")]);
                                            self.delegate?.ft_wallet(_wallet_: "-");
                                            self.delegate?.ft_skills(_skills_: [["-" : "-" as! Any]]);
                                            return ;
                                        }
                                        
                                        switch "\(jsonData_cursus.value)" {
                                        case "wethinkcode_":
                                            isWeThinkCode_ = 1;
                                            if (_WeThinkCode_) {
                                                if (tskills != nil) {
                                                    self.delegate?.ft_skills(_skills_: tskills!);
                                                    skills_access = false;
                                                }
                                                else {
                                                    skills_access = true;
                                                }
                                                
                                                if (tlevel != nil) {
                                                    self.delegate?.ft_level(_level_ : tlevel!);
                                                    level_access = false;
                                                }
                                                else {
                                                    level_access = true;
                                                }
                                            }
                                        case "bootcamp":
                                            isWeThinkCode_ = 2;
                                            if (!_WeThinkCode_) {
                                                if (tskills != nil) {
                                                    self.delegate?.ft_skills(_skills_: tskills!);
                                                    skills_access = false;
                                                }
                                                else {
                                                    skills_access = true;
                                                }
                                                if (tlevel != nil) {
                                                    self.delegate?.ft_level(_level_ : tlevel!);
                                                    level_access = false;
                                                }
                                                else {
                                                    level_access = true;
                                                }
                                            }
                                        default:
                                            break ;
                                        }
                                    }
                                }
                            }
                        }
                    }
                case "campus":
                    for jsonData_campus in (jsonData_L1.value as? [Any])! {
                        for jsonData_campus_values in (jsonData_campus as? [String : Any])! {
                            if (jsonData_campus_values.key == "name" && _WeThinkCode_) {
                            }
                        }
                    }
                case "projects_users":
                    for jsonData_L2 in jsonData_L1.value as! NSArray {
                        var project_details    : (String, String, String, String) = ("", "", "", "");
                        var project_name       : String = "";
                        var project_mark       : String = "";
                        var project_status     : String = "";
                        var project_validation : String = "";
                        for jsonData_L3 in jsonData_L2 as! [String : Any]{
                            if (jsonData_L3.key == "status") {
                                project_status = "\(jsonData_L3.value)";
                            }
                            if (jsonData_L3.key == "validated?") {
                                project_validation = "\(jsonData_L3.value)";
                            }
                            if (jsonData_L3.key == "final_mark") {
                                project_mark = "\(jsonData_L3.value)";
                            }
                            if (jsonData_L3.key == "project") {
                                var project_name : String = "";
                                for jsonData_L3_projects in jsonData_L3.value as! [String : Any] {
                                    if (jsonData_L3_projects.key == "name") {
                                        project_name = "\(jsonData_L3_projects.value)";
                                    }
                                    if (jsonData_L3_projects.key == "parent_id") {
                                        if ("\(jsonData_L3_projects.value)" != "<null>") {
                                            project_name = "{-} Not Valid {-}"
                                        }
                                    }
                                    if ("\(jsonData_L3_projects.key)" == "slug"  && "\(jsonData_L3_projects.value)".range(of:"bootcamp") == nil) {
                                        if (project_name != "{-} Not Valid {-}") {
                                            project_details = (project_name, project_mark, project_status, project_validation);
                                            projects_details += [project_details];
                                        }
                                    }
                                }
                            }
                        }
                    }
                default:
                    break ;
                }
                self.delegate?.ft_projects(_project_: projects_details);
            }
        }
    }
}
