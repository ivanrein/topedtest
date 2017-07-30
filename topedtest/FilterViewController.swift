//
//  FilterViewController.swift
//  topedtest
//
//  Created by Ivan Reinaldo on 7/27/17.
//  Copyright © 2017 rei. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UINavigationControllerDelegate, CustomSliderDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK outlets
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var wsSwitcher: UISwitch!
    @IBOutlet weak var slider: UICustomSlider!
    @IBOutlet weak var maxPriceLabel: UILabel!
    
    @IBAction func applyButton(_ sender: Any) {
        UserDefaults.standard.register(defaults: ["pmin" : slider.realLowerValue])
        UserDefaults.standard.register(defaults: ["pmax" : slider.realUpperValue])
        UserDefaults.standard.register(defaults: ["wholesale": wsSwitcher.isOn])
        UserDefaults.standard.register(defaults: ["official": dictSettings["official"]])
        UserDefaults.standard.register(defaults: ["gold": dictSettings["gold"]])
    }
    
    
    @IBOutlet weak var shoptypecollection: UICollectionView!
    var shopTypeCells = [String]()
    var dictSettings = [String:Bool]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        minPriceLabel.text = "Rp. \(UserDefaults.standard.integer(forKey: "pmin").formattedWithSeparator)"
        maxPriceLabel.text = "Rp. \(UserDefaults.standard.integer(forKey: "pmax").formattedWithSeparator)"
        slider.lowerValue = CGFloat(UserDefaults.standard.integer(forKey: "pmin") - 100) / CGFloat(9999900)
        slider.upperValue = CGFloat(UserDefaults.standard.integer(forKey: "pmax") - 100) / CGFloat(9999900)
        wsSwitcher.isOn =  UserDefaults.standard.bool(forKey: "wholesale")
        slider.delegate = self
        
        
       
        if UserDefaults.standard.bool(forKey: "official"){
            shopTypeCells.append("Official Store")
            dictSettings["official"] = true
        }else{
            dictSettings["official"] = false
        }
        if UserDefaults.standard.bool(forKey: "gold"){
            shopTypeCells.append("Gold Seller")
            dictSettings["gold"] = true
        }else {
            dictSettings["gold"] = false
        }
        
        shoptypecollection.register(UINib(nibName: "ShopTypeCellView", bundle: nil), forCellWithReuseIdentifier: "shoptypecell")
        shoptypecollection.delegate = self
        shoptypecollection.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        shoptypecollection.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width / 2 - 1
        let h = w * 0.3
        return CGSize(width: w, height: h)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let searchVC = viewController as? UISearchViewController{
            searchVC.reloadSettings()
        }
    }

    func customSliderOnValueChanged(lower: Float, upper: Float) {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        
        minPriceLabel.text = "Rp. \(Int(lower).formattedWithSeparator)"
        
        
        maxPriceLabel.text = "Rp. \(Int(upper).formattedWithSeparator)"
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let s = shopTypeCells[indexPath.row]
        shopTypeCells.remove(at: indexPath.row)
        if(s == "Official Store"){
            
            dictSettings["official"] = false
        }else if(s == "Gold Seller"){
            dictSettings["gold"] = false
        }
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shoptypecell", for: indexPath) as! UIShopTypeViewCell
        cell.shopLabel.text = shopTypeCells[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return shopTypeCells.count
    }
    
    
    
    
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Integer {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
