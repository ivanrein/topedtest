//
//  ShopTypeViewController.swift
//  topedtest
//
//  Created by Ivan Reinaldo on 7/28/17.
//  Copyright © 2017 rei. All rights reserved.
//

import UIKit


class CustomTableViewCell: UITableViewCell{
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var checkbox: CheckboxView!
    
    
}

class ShopTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var types = ["Official Store", "Gold Seller"]
    var settingnames = SettingConstants.shoptypes
    var settings = [Bool](repeating: false, count: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index, item) in settingnames.enumerated() {
            settings[index] = UserDefaults.standard.bool(forKey: settingnames[index])
        }
        navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func apply(_ sender: Any) {
        for row in 0...1 {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! CustomTableViewCell
            settings[row] = cell.checkbox.isChecked
            UserDefaults.standard.register(defaults: [settingnames[row]:settings[row]])
        }
        
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.typeLabel.text = types[indexPath.row]
        cell.checkbox.isChecked = settings[indexPath.row]
        
        return cell
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? FilterViewController {
            
            vc.shopTypeCells = [String]()
            for (index, item) in settings.enumerated() {
                if item {
                    vc.shopTypeCells.append(types[index])
                    
                }
                vc.dictSettings[settingnames[index]] = item
            }
            
            vc.shoptypecollection.reloadData()
        }
    }
}
