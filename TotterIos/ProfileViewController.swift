//
//  ProfileViewController.swift
//  TotterIos
//
//  Created by Developer on 04/06/2018.
//  Copyright © 2018 Ynov. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift
import SwiftyJSON

class ProfileViewController: UIViewController {
    var recevedUsername:String=""
    let keychain=KeychainSwift()
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var nickname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getUser(){
        Alamofire.request("http://localhost:1337/user/username/"+recevedUsername,method: .get,headers:baseHeaders.getHeaders()).validate().responseJSON{ response in
            switch response.result{
            case .success:
                do{
                    let user = try JSON(data:response.data!)
                    self.username.text=user["user"]["username"].stringValue
                    self.nickname.text=user["user"]["nickname"].stringValue
                }
                catch{
                    print("error")
                }
            case .failure:
                print("error")
            }
            
        }
    }

    @IBAction func subscribe(_ sender: UIButton) {
        let parameters=["username":self.recevedUsername]
        Alamofire.request("http://localhost:1337/subscription/subscribetosomeone",method: .post,parameters:parameters,headers:baseHeaders.getHeaders()).validate().responseJSON{
            response in
            switch response.result{
            case .success:
                print("subscribed")
            
            case .failure:
                print("failed to subscribe")
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
