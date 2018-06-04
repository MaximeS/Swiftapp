//
//  TotsViewController.swift
//  TotterIos
//
//  Created by Developer on 18/05/2018.
//  Copyright © 2018 Ynov. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift
import SwiftyJSON

class TotsViewController: UIViewController {
    var keychain:KeychainSwift!
    var tots:[Message]!
    @IBOutlet weak var totTableView: UITableView!
    override func loadView() {
        super.loadView()
        tots=[]
        self.keychain=KeychainSwift()
        self.getTots()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        totTableView.dataSource = self
        totTableView.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signout(_sender:UIButton){
        self.keychain.delete("token")
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Login") else { fatalError() }
        self.navigationController?.setViewControllers([controller], animated: true)
    }
    func getTots() {
        print("entering getTots function")
        Alamofire.request("http://localhost:1337/messages/followedTots",method:.get,headers:baseHeaders.getHeaders()).validate().responseJSON{response in
            print("Trying to get tots")
            switch response.result{
            case .success:
                do{
                    //print("success")
                    let JSONResponse = try JSON(data: response.data!)
                    //print(JSONResponse["followedtots"])
                    var myArr = JSONResponse["followedtots"].array!
                    var messageArr :[Message]=[]
                    var i=0
                    var y=0
                    while i < myArr.count{
                        
                            //print(myArr[i]["owner"].stringValue)
                        Alamofire.request("http://localhost:1337/user/getuserbyid/"+myArr[i]["owner"].stringValue,method:.get,headers:baseHeaders.getHeaders()).validate().responseJSON{response in
                        //print("trying to get tots owners")
                            switch response.result{
                            case .success:
                                do{
                                    //print("success")
                                    let OwnerResponse = try JSON(data: response.data!)
                                    var user = OwnerResponse["user"]
                                    messageArr.append(Message(message: myArr[y]["fullMessage"].stringValue,user :User(username:user["username"].stringValue,nickname:user["nickname"].stringValue,firstname : user["firstName"].stringValue,lastname:user["lastName"].stringValue),creationDate :myArr[y]["createdAt"].stringValue))
                                    //print(y)
                                    if(y==myArr.count-1)
                                    {
                                        self.reloadData(data:messageArr)
                                    }
                                    y+=1
                                }
                                catch
                                {
                                    print("failed to parse response")
                                }
                            case .failure:
                                print("failure in getting owner")
                            }
                    }
                        i+=1
                    }
                }
                catch
                {
                    print(error)
                }
            case .failure:
                print("no followedtots")
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "profile"){
            let profileVC = segue.destination as! ProfileViewController
            profileVC.recevedUsername=tots[(totTableView.indexPathForSelectedRow?.row)!].user.username
        }
    }
    func reloadData(data:[Message])
    {
        self.tots=data
        self.totTableView.reloadData()
    }
    @IBAction func addTot(_ sender: UIButton) {
        performSegue(withIdentifier: "addTot", sender: self)
    }
}

extension TotsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tots.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let row = indexPath.row
            var cell = totTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! TotTableViewCell;
            cell.message?.text = tots[row].message
            cell.username?.text = tots[row].user.username
            cell.date?.text = tots[row].creationDate
            print("test")
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        performSegue(withIdentifier: "profile", sender: self)
    }
}
