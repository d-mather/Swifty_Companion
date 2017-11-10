import Foundation

public protocol UserControlDelegate: class {
    func ft_login (_login_ : String);
    func ft_email (_email_ : String);
    func ft_level (_level_ : String);
    func ft_wallet (_wallet_ : String);
    func ft_picture (_picture_url_ : String);
    func ft_skills (_skills_ : [[String : Any]]);
    func ft_display_name (_display_name_ : String);
    func ft_error(_type_ : String, _message_ : String);
    func ft_correction_points (_correction_points_ : String);
    func ft_projects(_project_ : [(String, String, String, String)]);
}
