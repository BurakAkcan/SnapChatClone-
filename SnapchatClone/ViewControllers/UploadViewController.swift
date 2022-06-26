//
//  UploadViewController.swift
//  SnapchatClone
//
//  Created by Burak AKCAN on 25.06.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var uploadImage: UIImageView!
    var chooseImage:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImage.isUserInteractionEnabled = true
        let gestureReco = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        uploadImage.addGestureRecognizer(gestureReco)
        

    }
    
    @IBAction func uploadClick(_ sender: UIButton) {
        if chooseImage {
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            let mediaFolder = storageRef.child("media")
            
            if let imageData = uploadImage.image?.jpegData(compressionQuality: 0.4){
                let uuid = UUID().uuidString
                let imageRef = mediaFolder.child("\(uuid).jpg")
                chooseImage = false
                imageRef.putData(imageData) { metadata, error in
                    if error != nil {
                        print(error?.localizedDescription ?? "error")
                    }else{
                        imageRef.downloadURL { url, error in
                            if error == nil {
                                let imageUrl = url?.absoluteString
                                let firestore = Firestore.firestore()
                                
                                //
                                firestore.collection("snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedInstance.email).getDocuments { snapshot, error in
                                    if error != nil {
                                        print(error?.localizedDescription ?? "error")
                                    }else{
                                        if snapshot?.isEmpty == false && snapshot != nil{
                                            for doc in snapshot!.documents{
                                                let docId = doc.documentID
                                                if var imageUrlList = doc.get("imageUrl") as? [String]{
                                                    imageUrlList.append(imageUrl!)
                                                    let addDictionry = ["imageUrl":imageUrlList] as [String:Any]
                                                    firestore.collection("snaps").document(docId).setData(addDictionry, merge: true) { error in
                                                        if error == nil {
                                                            self.tabBarController?.selectedIndex = 0
                                                            self.uploadImage.image = UIImage(named: "ic_upload")
                                                        }else{
                                                            print(error?.localizedDescription ?? "error")
                                                        }
                                                    }
                                                }
                                            }
                                        }else{//Kullanıcı hiç resim yüklemediyse
                                            let snapDictionary = ["imageUrl":[imageUrl!],"snapOwner": UserSingleton.sharedInstance.email,"date":FieldValue.serverTimestamp()] as [String:Any]
                                            firestore.collection("snaps").addDocument(data: snapDictionary) { error in
                                                if error != nil {
                                                    print(error?.localizedDescription ?? "error")
                                                }else{
                                                    self.tabBarController?.selectedIndex = 0
                                                    self.uploadImage.image = UIImage(named: "ic_upload")
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                
                                
                            }
                        }
                    }
                }
            }
            
        }
        
        
        
    }
    
    @objc func addPhoto(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        uploadImage.image = info[.originalImage] as? UIImage
        chooseImage = true
        self.dismiss(animated: true)
        
    }
}
