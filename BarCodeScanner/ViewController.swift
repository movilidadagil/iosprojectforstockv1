//
//  ViewController.swift
//  BarCodeScanner
//
//  Created by 1 on 11/27/20.
//

import UIKit
import SQLite
import FirebaseFirestore

class ViewController: UIViewController {
    @IBOutlet weak var scanBarButton: UIButton!
    @IBOutlet weak var scanTextField: UITextField!
    var db: Connection?
    let productBarcode = ""
    let productName = ""
    let productCount = ""
    let productPrice =  ""
    let tblKardelen = Table("kardelenPRD")
    let dbProductBarcode = Expression<String>("productBarcode")
    let dbProductName = Expression<String>("productName")
    let dbProductCount = Expression<Double>("productCount")
    let dbProductPrice = Expression<Double>("productPrice")
    
    var productArray=[Product]()

    
    /*
     scanBarButton.backgroundColor = UIColor.systemYellow
     scanBarButton.setTitle("Scan Bar Code", for: .normal)
     scanBarButton.setTitleColor(UIColor.white, for: .normal)
     scanBarButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Thin" , size: 25)
     scanBarButton.addTarget(self, action: #selector(scanBarTapped), for: .touchUpInside)
     
     scanTextField.text = "Default"
     scanTextField.textAlignment = .center
     scanTextField.textColor = UIColor.white
     scanTextField.font = (UIFont(name: "AppleSDGothicNeo-Bold", size: 25))
     */
    /*let scanBarButton : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.layer.cornerRadius = 22
        btn.setTitle("Barkodu Okut", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.darkGray, for: .disabled)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(scanBarTapped), for: .touchUpInside)
        return btn
    }()
    
    let scanTextField : CustomTextField = {
        let txt = CustomTextField(padding:15)
        txt.backgroundColor = .white
        txt.placeholder = "Barkod Numarası"
        txt.keyboardType = .alphabet
        txt.addTarget(self, action: #selector(catchTextFieldChange), for: .editingChanged)
        
        return txt
    }()
    */
    
    var row_id = ""
    
    let txtProductName : CustomTextField = {
        let txt = CustomTextField(padding:15)
        txt.backgroundColor = .white
        txt.placeholder = "Ürün İsmi"
        txt.keyboardType = .alphabet
        txt.addTarget(self, action: #selector(catchTextFieldChange), for: .editingChanged)
        txt.isEnabled = false

        return txt
    }()
    
    let txtProductBarcode: CustomTextField = {
        let txt = CustomTextField(padding:15)
        txt.backgroundColor = .white
        txt.placeholder = "Ürün Barkodu"
        txt.keyboardType = .alphabet
        txt.addTarget(self, action: #selector(catchTextFieldChange), for: .editingChanged)
        
        return txt
    }()
    
    
    let txtProductCount : CustomTextField = {
        let txt = CustomTextField(padding:15)
        txt.backgroundColor = .white
        txt.placeholder = "Ürün Adet"
        txt.keyboardType = .alphabet
        txt.addTarget(self, action: #selector(catchTextFieldChange), for: .editingChanged)
        
        return txt
    }()
    
    
    let txtProductPrice : CustomTextField = {
        let txt = CustomTextField(padding:15)
        txt.backgroundColor = .white
        txt.placeholder = "Ürün Fiyat"
        txt.keyboardType = .alphabet
        txt.addTarget(self, action: #selector(catchTextFieldChange), for: .editingChanged)
        
        return txt
    }()
    
    let btnStockRecorder : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.layer.cornerRadius = 22
        btn.setTitle("Kaydet", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.darkGray, for: .disabled)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(btnStockPressed), for: .touchUpInside)
        return btn
    }()
    
    let btnStockShow : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.layer.cornerRadius = 22
        btn.setTitle("Listele", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.darkGray, for: .disabled)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(btnStockShowPressed), for: .touchUpInside)
        return btn
    }()
    
    let btnStockRetrieveFromFirebase : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.layer.cornerRadius = 22
        btn.setTitle("GETİR", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.darkGray, for: .disabled)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(btnStockRetrievePressed), for: .touchUpInside)
        return btn
    }()
    
    
    fileprivate func backgroundGradientSet()
    {
        let upColor : CGColor = .init(red: 0, green: 20, blue: 20, alpha: 20)
        let bottomColor : CGColor = .init(red: 41, green: 41, blue: 41, alpha: 41)
        gradient.colors = [upColor, bottomColor]
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.bounds
        print("backGrounGradientSet \(view.bounds)")
    }
    
    @objc fileprivate func btnPhotoChooserPressed(){
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        present(imgPickerController, animated: true, completion: nil)
    }
    
    
    @objc fileprivate func keyboardClose(){
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    
    
    @objc fileprivate func btnStockShowPressed(){
        print("btnstockshow  is clicked")
        let productlistController = ProductListViewController()
        present(productlistController, animated: true)
    }
    
    @objc fileprivate func btnStockRetrievePressed() {
        print("btnstockretrieve  is clicked")
        
         Firestore.firestore().collection("Products").getDocuments{ (snapshot, error) in
             
             if let error = error {
                 print("PRoducts could not retrieved: \(error)")
                 return
             }
             var condition = false
             
             snapshot?.documents.forEach({(dSnapshot) in
                 
                 let productsData  = dSnapshot.data()
                 //print(productsData)
                 let tmpProduct = Product.init(data: productsData)
                 print(tmpProduct.productCount)
                 print(tmpProduct.productName)
                 print(tmpProduct.productPrice)
                 print(tmpProduct.productBarcode)

                 if(tmpProduct.productBarcode == self.txtProductBarcode.text){
                     self.txtProductName.text = tmpProduct.productName
                     self.txtProductCount.text = String(tmpProduct.productCount)
                     self.txtProductPrice.text = String(tmpProduct.productPrice)
                     condition = true
                 }
                 else{
                     if condition == false {
                            self.txtProductName.text =  "ürün bulunamadı"
                            self.txtProductName.isEnabled = true
                            self.txtProductPrice.text = ""
                            self.txtProductCount.text = ""

                     }
                     
                 }
                 self.productArray.append(tmpProduct)
                    // count=count+1
             })
         
         }
        
      
    }
  
    
    @objc fileprivate func btnStockPressed(completion : @escaping (Error?) ->()){
        self.keyboardClose()
        guard let productBarcode = txtProductBarcode.text else {return }
        guard let productName = txtProductName.text else {return }
        guard let productCount = txtProductCount.text else {return}
        guard let productPrice = txtProductPrice.text else {return }
        
        print(txtProductBarcode.text)
        print(txtProductName.text)
        print(txtProductCount.text)
        print(txtProductPrice.text)

        
        do {
            let insert = self.tblKardelen.insert(dbProductBarcode <- productBarcode, dbProductName <- productName, dbProductCount <- Expression<Double>(productCount),
            dbProductPrice <- Expression<Double>(productPrice))
            let rowid = try db!.run(insert)
            row_id = String(rowid)
            print("Row inserted successfully id: \(rowid)")
            self.stockInfoRecordToFireStore(productBarcode: productBarcode,
                                            productName: productName,
                                            productCount: productCount,
                                            productPrice: productPrice,
                                            completion: completion)
            
          
        } catch {
            print("insertion failed: \(error)")
        }
        
        /*let rowCount=dbSelectOperation()
        if(rowCount>0)
        {
            
            print ("data available in the database")
            //downloading weather data for the all information in database
            for prdc in productArray{
                let count = String(prdc.productCount)
                let price = String(prdc.productPrice)
                let name = String(prdc.productName)
                let barcode = String(prdc.productBarcode)
                print(name)
                print(count)
                print(price)
                print(barcode)

            }
        }
        else
        {
            print ("database empty")
        }*/
        
       
    }
    
    fileprivate func stockInfoRecordToFireStore(productBarcode : String,
                                                productName : String,
                                                productCount : String,
                                                productPrice : String,
                                                completion : @escaping (Error?) -> ()){
        let insertionData = ["ProductName": productName ?? "",
                            "ProductCount": productCount ?? "",
                            "ProductPrice": productPrice ?? "",
                            "ProductBarcode":  productBarcode ?? "",
                             "ProductId": row_id ?? ""]
        
        Firestore.firestore().collection("Products").document(productBarcode+"-"+row_id).setData(insertionData) {
            (error) in
            if let error = error {
                completion(error)
                return
            }
            
        }
        
    }
    
    func dbSelectOperation() -> Int
    {
        var count=0
        do{
        for prdc in try db!.prepare(tblKardelen) {
            print("product: \(prdc[dbProductName]), count: \(prdc[dbProductCount]), price: \(prdc[dbProductPrice]), barkodu: \(prdc[dbProductBarcode])")
       
            let tmpProduct = Product(data: ["":""])
            tmpProduct.productName=prdc[dbProductName]
            tmpProduct.productCount=prdc[dbProductCount]
            tmpProduct.productPrice=prdc[dbProductPrice]
            tmpProduct.productBarcode=prdc[dbProductBarcode]
            
            productArray.append(tmpProduct)
                count=count+1
            }
        }
        catch {
            print ("selection error: \(error)")
        }
        
        return count
    }
    
    let btnPhotoChooser : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Resim Yükle", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        
        btn.layer.cornerRadius = 15
        btn.heightAnchor.constraint(equalToConstant: 280).isActive = true
        btn.addTarget(self, action: #selector(btnPhotoChooserPressed), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var barcodeStackView : UIStackView = {
        let vSv = UIStackView(arrangedSubviews: [
           scanBarButton
           //scanTextField
        ])
        vSv.axis = .vertical
        vSv.distribution = .fillEqually
        vSv.spacing = 10
        
        return vSv
    }()
    
    lazy var verticalStackView : UIStackView = {
        
        let vSv = UIStackView(arrangedSubviews: [
            txtProductBarcode,
            btnStockRetrieveFromFirebase,
            txtProductName,
            txtProductCount,
            txtProductPrice,
            btnStockRecorder,
            btnStockShow
        ])
        vSv.axis = .vertical
        vSv.distribution = .fillEqually
        vSv.spacing = 10
        
        return vSv
    }()
    
    fileprivate func createNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(catchKeyboardView(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(catchKeyboardHideView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func catchKeyboardHideView(notification:Notification){
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    
    @objc fileprivate func catchKeyboardView(notification:Notification){
        // print(notification.userInfo)
        
        guard let keyboardEndValues = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardEndFrame = keyboardEndValues.cgRectValue
        
        print(keyboardEndFrame)
        print("\(keyboardEndFrame.width) - \(keyboardEndFrame.height)")
        
        guard let keyboardStartValues = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let keyboardStartFrame = keyboardStartValues.cgRectValue
        
        print(keyboardStartFrame)
        print("\(keyboardStartFrame.width) - \(keyboardStartFrame.height)")
        
        let bottomSpaceAmount = view.frame.height - (stockStackView.frame.origin.y + stockStackView.frame.height)
        
        print(bottomSpaceAmount)
        
        let faultRate = keyboardEndFrame.height - bottomSpaceAmount
        print(faultRate)
        self.view.transform = CGAffineTransform(translationX: 0, y: -faultRate)
    }
    fileprivate func addTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardClose)))
    }
    
    lazy var stockStackView = UIStackView(arrangedSubviews: [
                                                             barcodeStackView
                                                              , verticalStackView
                                                              
                                                             ])
    
    let scannerViewController = ScannerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.systemBlue
        updateUI()
        backgroundGradientSet()
        // Do any additional setup after loading the view.
        setLayout()
        scannerViewController.delegate = self
        createStockViewModelObserver()
        createNotificationObserver()
        addTapGesture()

        dbSetup()
        
    }
  
    func dbSetup()
    {
        let databaseFileName = "db.sqlite3"
        let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(databaseFileName)"
        db = try! Connection(databaseFilePath)

        
        try! db!.run(tblKardelen.create(ifNotExists: true) { t in
            t.column(dbProductBarcode)
            t.column(dbProductName)
            t.column(dbProductCount)
            t.column(dbProductPrice)
        })
    }
    
    fileprivate func setLayout(){
        
        view.addSubview(stockStackView)
        stockStackView.axis = .vertical
        btnPhotoChooser.widthAnchor.constraint(equalToConstant: 260).isActive = true
        stockStackView.spacing = 10
        _ = stockStackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor
                                   ,padding: .init(top: 0, left: 45, bottom: 0, right: 45))
        stockStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    let gradient = CAGradientLayer()

    let stockViewModel = StockViewModel()

    fileprivate func createStockViewModelObserver(){
        stockViewModel.stockDataValidObserver = {
            (valid) in
            print("stock record valid", valid ? " form valid ": "form invalid")
            self.btnStockRecorder.isEnabled = valid
            
            if valid == true {
                self.btnStockRecorder.backgroundColor = .blue
                self.btnStockRecorder.setTitleColor(.white, for: .normal)
            }
            else{
                self.btnStockRecorder.backgroundColor = .lightGray
                self.btnStockRecorder.setTitleColor(.darkGray, for: .disabled)
            }
        }
        
        stockViewModel.imgProfileObserver = { (imgProfile) in
            self.btnPhotoChooser.setImage(imgProfile?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        
    }
    
    @objc fileprivate func catchTextFieldChange(textField: UITextField){
        print("Editing: ", textField.text ?? "")
        if textField == txtProductName {
            //print("password")
            stockViewModel.productName = textField.text
        }
        else if textField == txtProductCount {
            //print("namesurname")
            stockViewModel.productCount = textField.text
            
        }
        
        else if textField == txtProductPrice {
            //print("email address")
            stockViewModel.productPrice = textField.text
        }
        
        /*let dataValid = txtPassword.text?.isEmpty == false
         &&  txtNameSurname.text?.isEmpty == false
         && txtEmailAddress.text?.isEmpty == false
         btnSignup.isEnabled = dataValid
         
         if dataValid == true {
         btnSignup.backgroundColor = .blue
         btnSignup.setTitleColor(.white, for: .normal)
         }
         else{
         btnSignup.backgroundColor = .lightGray
         btnSignup.setTitleColor(.darkGray, for: .disabled)
         }*/
    }
}

extension ViewController: ScannerViewDelegate {
    func didFindScannedText(text: String) {
        scanTextField.text = text
        print("bingo goes on")
        txtProductBarcode.text = text
        
    }
}

extension ViewController {
    private func updateUI() {
        scanBarButton.backgroundColor = UIColor.systemYellow
        scanBarButton.setTitle("Scan Bar Code", for: .normal)
        scanBarButton.setTitleColor(UIColor.white, for: .normal)
        scanBarButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Thin" , size: 25)
        scanBarButton.addTarget(self, action: #selector(scanBarTapped), for: .touchUpInside)
        
        scanTextField.text = "Default"
        scanTextField.textAlignment = .center
        scanTextField.textColor = UIColor.white
        scanTextField.font = (UIFont(name: "AppleSDGothicNeo-Bold", size: 25))
        //self.createStockViewModelObserver()
        
        
    }
    
    @objc func scanBarTapped() {
        self.navigationController?.pushViewController(scannerViewController, animated: true)
    }
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImg = info[.originalImage] as? UIImage
        stockViewModel.imgProfile = selectedImg
        
        dismiss(animated: true, completion: nil)
    }
}

