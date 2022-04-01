//
//  ProductlistController.swift
//  BarCodeScanner
//
//  Created by Hasan Hüseyin Ali Gül on 31.03.2022.
//

import UIKit
import SQLite
import FirebaseFirestore

class ProductListViewController : UIViewController {
   
    let productsTableView = UITableView() // view
    
    var db: Connection?
    var productArray=[Product]()

    let tblKardelen = Table("kardelenPRD")
    let dbProductBarcode = Expression<String>("productBarcode")
    let dbProductName = Expression<String>("productName")
    let dbProductCount = Expression<Double>("productCount")
    let dbProductPrice = Expression<Double>("productPrice")
    
    
    lazy var verticalStackView : UIStackView = {
        
        let vSv = UIStackView(arrangedSubviews: [
            productsTableView
        ])
        vSv.axis = .vertical
        vSv.distribution = .fillEqually
        vSv.spacing = 10
        
        return vSv
    }()
    
    fileprivate func setLayout(){
        view.addSubview(productsTableView)

        productsTableView.translatesAutoresizingMaskIntoConstraints = false

        productsTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        productsTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        productsTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        productsTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        productsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "productCell")

        callDelegates()

        // Do any additional setup after loading the view.
        dbSetup()
        loadData()


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
    func dbSelectOperation() -> Int
    {
        var count=0
        do{
        for prdc in try db!.prepare(tblKardelen) {
            print("product: \(prdc[dbProductName]), count: \(prdc[dbProductCount]), price: \(prdc[dbProductPrice]), barkodu: \(prdc[dbProductBarcode])")
       
            let tmpProduct = Product(data: ["ProductName" : "ProductName"])
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
    func loadData(){
        
       
        Firestore.firestore().collection("Products").getDocuments{ (snapshot, error) in
            
            if let error = error {
                print("PRoducts could not retrieved: \(error)")
                return
            }
            
            snapshot?.documents.forEach({(dSnapshot) in
                
                let productsData  = dSnapshot.data()
                print(productsData)
                let tmpProduct = Product.init(data: productsData)
                self.productArray.append(tmpProduct)
                   // count=count+1
                self.productsTableView.reloadData()
            })
        
        }
        /*let rowCount=dbSelectOperation()
        if(rowCount>0)
        {
            self.productsTableView.reloadData()

            
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
    
    func callDelegates()
    {
        productsTableView.delegate=self
        productsTableView.dataSource=self
    }
    
}

extension ProductListViewController:UITableViewDelegate,UITableViewDataSource
{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count: String = String(format: "%.1f",productArray[indexPath.row].productCount )
        let price: String = String(format: "%.1f",productArray[indexPath.row].productPrice )

        let productName = productArray[indexPath.row].productName
        let productBarcode = productArray[indexPath.row].productBarcode

        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        cell.textLabel?.text = (productName ?? "") + " adet: " + count + " fiyat: " + price + " " + (productBarcode ?? "")
        //cell.configureFavCell(productData:productArray[indexPath.row])

        return cell
       /* let cell=productsTableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductCell
        cell.configureFavCell(productData:productArray[indexPath.row])
        return cell*/
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    

    
    
}
