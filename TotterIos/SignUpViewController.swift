//
//  SignUpViewController.swift
//  TotterIos
//
//  Created by Developer on 18/05/2018.
//  Copyright © 2018 Ynov. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift
import SwiftyJSON

class SignUpViewController: UIViewController {
    var keychain:KeychainSwift!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        keychain=KeychainSwift()
        if let token = keychain.get("token") {
            print ("trying to test if i'm logged in")
            loggedIn(animated: false)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loggedIn(animated:Bool){
        let headers=["Authorization":"JWT "+keychain.get("token")!]
        Alamofire.request("http://localhost:1337/user/me",method: .get,headers:headers).validate().responseJSON{response in
            switch response.result{
            case .success:
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Tots") else { fatalError() }
                self.navigationController?.setViewControllers([controller], animated: animated)
            case .failure:
                print("Not Logged")
            }
        }
    }
    @IBAction func signup(_ sender: UIButton) {
        let parameters=[
            "username":username.text!,
            "password":password.text!,
            "nickname":nickname.text!,
            "firstName":firstname.text!,
            "lastName":lastname.text!
        ]
        Alamofire.request("http://localhost:1337/auth/signup",method: .post,parameters:parameters).validate().responseJSON{response in
            switch response.result{
            case .success:
                do{
                    let JSONResponse = try JSON(data: response.data!)
                    self.keychain.set(JSONResponse["token"].stringValue,forKey:"token")
                    self.loggedIn(animated: true)
                }
                catch{
                    print(error)
                }
            case .failure:
                print("Error while Signing up")
            }
        }
    }
}
