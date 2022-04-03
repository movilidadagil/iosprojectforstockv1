//
//  MainScreenViewController.swift
//  BarCodeScanner
//
//  Created by Hasan Hüseyin Ali Gül on 2.04.2022.
//

import UIKit
class MainScreenViewController : UIViewController {
    let btnStockRecorder : UIButton = {
        
        let btn = UIButton(type: .system)
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.layer.cornerRadius = 22
        btn.setTitle("Kaydet", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.darkGray, for: .disabled)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(btnStockPressed), for: .touchUpInside)
        return btn
    }()
    @objc fileprivate func btnStockPressed(){
        print("btnstockshow  is clicked")
        btnStockRecorder.isHidden = true
        let stockRecorderView = StockRecorderViewController()
        present(stockRecorderView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.systemBlue
        backgroundGradientSet()
        setLayout()
        
    }
    
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
    
    lazy var verticalStackView : UIStackView = {
        
        let vSv = UIStackView(arrangedSubviews: [
    
            btnStockRecorder
        ])
        vSv.axis = .vertical
        vSv.distribution = .fillEqually
        vSv.spacing = 10
        
        return vSv
    }()
    lazy var stockStackView = UIStackView(arrangedSubviews: [
                                                               verticalStackView
                                                              
                                                             ])
    fileprivate func setLayout(){
        
        view.addSubview(stockStackView)
        stockStackView.axis = .vertical
        stockStackView.spacing = 10
        _ = stockStackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor
                                   ,padding: .init(top: 0, left: 45, bottom: 0, right: 45))
        stockStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    let gradient = CAGradientLayer()
}
