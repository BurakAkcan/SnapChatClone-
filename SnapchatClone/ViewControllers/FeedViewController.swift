//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Burak AKCAN on 25.06.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var snapList:[Snap] = [] //Oluşturduğumuz modeli tutan oş bir liste tanımladık
    var choosenSnap:Snap?
    
    @IBOutlet weak var tableView: UITableView!
    let firestore = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getUserInfo()
        getSnapsData()

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableViewCell
        cell.userLabel.text = snapList[indexPath.row].username
        cell.snapImage.sd_setImage(with: URL(string: snapList[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
    func getSnapsData(){
        firestore.collection("snaps").order(by: "date",descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                self.custumAlert(title: "Error", message: error?.localizedDescription ?? "unknow error")
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapList.removeAll(keepingCapacity: false)
                    for doc in snapshot!.documents{
                        //silmek için lazım olan doc Id
                        let docId = doc.documentID
                        if let username = doc.get("snapOwner") as? String {
                            if let imageUrlList = doc.get("imageUrl") as? [String] {
                                if let date = doc.get("date") as? Timestamp {
                                    //TimeStamp i date.dateValue() şeklinde date objesi olarak yazdırabiliriz
                                    //Calendar saatler , yıllar ,aylar vs bunları karşılaştıracaksam bu objeyi kullanırız
                                    //from kaydedilen zaman to güncel zaman
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        if difference >= 24 {
                                            self.firestore.collection("snaps").document(docId).delete { error in
                                                if error != nil {
                                                    print(error?.localizedDescription ?? "delete snap error")
                                                }
                                            }
                                        }else{
                                            let snap = Snap(username: username, imageUrlArray: imageUrlList, date: date.dateValue(),timeDifference: 24 - difference)
                                            self.snapList.append(snap)
                                        }
                                        //Time left show user
                                     
                                        
                                        
                                        
                                    }
                                   
                                   
                                   
                                }
                            }
                        }
                           
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    

    func getUserInfo(){
        //Emaili aktif kullanıcın emaili olanı getir
        firestore.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email! ).getDocuments { snapshot, error in
            if error != nil {
                self.custumAlert(title: "Error", message: error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false  && snapshot != nil  {
                    for doc in snapshot!.documents{
                        if let username = doc.get("username") as? String {
                            UserSingleton.sharedInstance.username = username
                            UserSingleton.sharedInstance.email = Auth.auth().currentUser!.email!
                            
                        }
                    }
                }
            }
        }
    }
    
    
    func custumAlert(title:String,message:String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
        present(ac, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnap"{
            let destination = segue.destination as! SnapViewController
            destination.selectedSnap = choosenSnap
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenSnap = snapList[indexPath.row]
        performSegue(withIdentifier: "toSnap", sender: nil)
    }

}
