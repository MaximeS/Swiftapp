//
//  ViewController.swift
//  TotterIos
//
//  Created by Developer on 17/05/2018.
//  Copyright © 2018 Ynov. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift
import SwiftyJSON

class ViewController: UIViewController {
    var keychain:KeychainSwift!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keychain=KeychainSwift()
        
        if let token = keychain.get("token") {
            print ("trying to test if i'm logged in")
            loggedIn(animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signin(_sender:UIButton){
        let parameters=["username":self.username.text!,"password":self.password.text!]
        Alamofire.request("http://localhost:1337/auth/signin",method: .post,parameters:parameters).validate().responseJSON{response in
             switch response.result {
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
                    print("Error in request")
            }
        }
        
    }
    
    @IBAction func signup(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Signup") else { fatalError() }
        self.navigationController?.setViewControllers([controller], animated: true)
    }
    func loggedIn(animated:Bool){
        let headers=["Authorization":"JWT "+keychain.get("token")!]
        Alamofire.request("http://localhost:1337/user/me",method: .get,headers:headers).validate().responseJSON{response in
            switch response.result{
                case .success:
                    baseHeaders.setHeaders(headers: headers)
                    guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Tots") else { fatalError() }
                    self.navigationController?.setViewControllers([controller], animated: animated)
                case .failure:
                    print("Not Logged")
            }
        }
    }
    

}

