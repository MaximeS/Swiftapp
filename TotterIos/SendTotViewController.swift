//
//  SendTotViewController.swift
//  TotterIos
//
//  Created by Developer on 04/06/2018.
//  Copyright © 2018 Ynov. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift
import SwiftyJSON

class SendTotViewController: UIViewController {

    @IBOutlet weak var totMessage: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendTot(_ sender: UIButton) {
        let parameters=["fullMessage":totMessage.text!]
        Alamofire.request("http://localhost:1337/messages/addTot",method: .post,parameters: parameters,headers:baseHeaders.getHeaders()).validate().responseJSON{
            response in
            switch response.result{
            case .success:
                print("message envoyé")
            case .failure:
                print("message non envoyé")
            }
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
