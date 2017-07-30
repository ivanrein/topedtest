//
//  UISearchViewController.swift
//  topedtest
//
//  Created by Ivan Reinaldo on 7/27/17.
//  Copyright © 2017 rei. All rights reserved.
//

import UIKit

class UISearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var price = [String]()
    var imageurls = [String]()
    var names = [String]()
    
    
    var cellWidth:CGFloat = 0
    var cellHeight:CGFloat = 0
    
    var pmin = 100
    var pmax = 10000000
    var wholesale = false
    var official = true
    var fshop = 2
    var start = 0
    var row = 10
    
    var displayDataLowerBound = 0
    var displayDataUpperBound = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let layout =  UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 3
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        
        if UserDefaults.standard.object(forKey: "pmin") == nil {
            UserDefaults.standard.register(defaults: ["pmin":100])
            
        }
        if UserDefaults.standard.object(forKey: "pmax") == nil {
            UserDefaults.standard.register(defaults: ["pmax":10000000])
            
        }
        if UserDefaults.standard.object(forKey: "wholesale") == nil {
            UserDefaults.standard.register(defaults: ["wholesale" : false])
            
        }
        if UserDefaults.standard.object(forKey: "official") == nil {
            UserDefaults.standard.register(defaults: ["official" : true])
            
        }
        if UserDefaults.standard.object(forKey: "gold") == nil {
            UserDefaults.standard.register(defaults: ["gold" : true])
        }
        reloadSettings()
    }
    
    private func makeURL() -> URL {
        let urlstring = "https://ace.tokopedia.com/search/v2.5/product?q=samsung&pmin=\(pmin)&pmax=\(pmax)&wholesale=\(wholesale)&official=\(official)&fshop=\(fshop)&start=\(start)&rows=\(row)"
        return URL(string: urlstring)!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if(self.traitCollection.horizontalSizeClass == .compact){
//            cellWidth = collectionView.frame.width
//        }else{
//            cellWidth = collectionView.frame.width/2 - CGFloat(0.5)
//        }
        cellWidth = collectionView.frame.width
        cellHeight = 1.3 * cellWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func reloadSettings(){
        collectionView.contentOffset.y = 0
        
        pmin = UserDefaults.standard.integer(forKey: "pmin")
        pmax = UserDefaults.standard.integer(forKey: "pmax")
        wholesale = UserDefaults.standard.bool(forKey: "wholesale")
        official = UserDefaults.standard.bool(forKey: "official")
        fshop = UserDefaults.standard.bool(forKey: "gold") ? 2 : 0
        start = 0
        row = 10
        displayDataLowerBound = 0
        displayDataUpperBound = 10
        
        
        price = [String]()
        imageurls = [String]()
        names = [String]()
        collectionView.reloadData()
        let task = URLSession.shared.dataTask(with:  makeURL(), completionHandler: { [weak self] data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            if let arr = json["data"] as? [Any] {
                for item in arr{
                    if let itemjson = item as? [String:Any]{
                        self?.price.append(itemjson["price"] as! String)
                        self?.imageurls.append(itemjson["image_uri"] as! String)
                        self?.names.append(itemjson["name"] as! String)
                    }
                }
            }
            
            DispatchQueue.main.async{
                
                self?.collectionView.reloadData()
            
            }
            
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UISearchViewCell
        
        if(imageurls[indexPath.row] != ""){
            let task = URLSession.shared.dataTask(with: URL(string: imageurls[indexPath.row])!, completionHandler: {
                data, response, error in
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data!)
                }
                
                
            })
            task.resume()
        }else{
            cell.imageView.image = nil
        }
        cell.priceLabel.text = price[indexPath.row]
        cell.itemLabel.text = names[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(price.count)
        return price.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let coffset = scrollView.contentOffset
        let csize = scrollView.contentSize
        if(coffset.y > csize.height - scrollView.bounds.height){
            scrollView.contentOffset = CGPoint(x: coffset.x, y: coffset.y - cellHeight * 5)
            shiftDataSource(by: -5)
        }else if(coffset.y < 0 && displayDataLowerBound >= 5){
            scrollView.contentOffset = CGPoint(x: coffset.x, y: coffset.y + cellHeight * 5)
            shiftDataSource(by: 5)
        }
    }
    
  
    private func shiftDataSource(by: Int){
        if(by < 0){
            let bby = -by
            
            price.removeSubrange(0..<bby)
            imageurls.removeSubrange(0..<bby)
            names.removeSubrange(0..<bby)
            for _ in 0..<bby{
                price.append("")
                imageurls.append("")
                names.append("")
            }
            
            
            collectionView.reloadData()
            
            start = displayDataUpperBound
            displayDataLowerBound += bby
            displayDataUpperBound += bby
            
            row = bby
            let task = URLSession.shared.dataTask(with: makeURL(), completionHandler: { [weak self] data, response, error in
                guard error == nil else {
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Data is empty")
                    return
                }
                
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                if let arr = json["data"] as? [Any] {
                    for (index,item) in arr.enumerated(){
                        if let itemjson = item as? [String:Any]{
                            print(bby+index)
                            self?.price[bby+index] = itemjson["price"] as! String
                            self?.imageurls[bby+index] = itemjson["image_uri"] as! String
                            self?.names[bby+index] = itemjson["name"] as! String
                        }
                    }
                }
                
                DispatchQueue.main.async{
                    self?.collectionView.reloadData()
                    
                }
                
            })
            
            task.resume()

        }else{
            let startRemove = price.count - by
            price.removeSubrange(startRemove..<price.count)
            imageurls.removeSubrange(startRemove..<price.count)
            names.removeSubrange(startRemove..<price.count)
            for _ in 0..<by {
                price.insert("", at: 0)
                imageurls.insert("", at: 0)
                names.insert("", at: 0)
            }
            collectionView.reloadData()
            row = by
            displayDataLowerBound = max(0, displayDataLowerBound - by)
            displayDataUpperBound = max(10, displayDataUpperBound - by)
            start = displayDataLowerBound
            let task = URLSession.shared.dataTask(with: makeURL(), completionHandler: { [weak self] data, response, error in
                guard error == nil else {
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Data is empty")
                    return
                }
                
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                if let arr = json["data"] as? [Any] {
                    for (index,item) in arr.enumerated(){
                        if let itemjson = item as? [String:Any]{
                            self?.price[index] = itemjson["price"] as! String
                            self?.imageurls[index] = itemjson["image_uri"] as! String
                            self?.names[index] = itemjson["name"] as! String
                        }
                    }
                }
                
                DispatchQueue.main.async{
                    self?.collectionView.reloadData()
                    
                }
                
            })
            task.resume()
            
        }
    }

}
