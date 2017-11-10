//
//  SubViewController.swift
//  Swifty Companion
//
//  Created by Dillon MATHER on 2017/11/01.
//  Copyright © 2017 Dillon MATHER. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.youtube.com/channel/UCiKHYSvsnqDxE3J6ea8E6CQ?view_as=subscriber")
        myWebView.loadRequest(URLRequest(url: url!))
    }

}
