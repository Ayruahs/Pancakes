//
//  ViewController.swift
//  Pancakes
//
//  Created by Shaurya Sinha on 26/05/17.
//  Copyright © 2017 Shaurya Sinha. All rights reserved.
//

import UIKit


class MenuSearchViewController: UIViewController {

    @IBOutlet weak var foodSearchField: UITextField!
    
    
    @IBAction func searchButton(_ sender: Any) {
        //foodSearchField.text
    }
    
    // Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier{
            case "Show Table":
                if let destNavController = segue.destination as? UINavigationController{
                    let targetController = destNavController.topViewController as! TableViewController
                    
                    targetController.URLString = "https://api.hfs.purdue.edu/menus/v2/items/searchUpcoming/" + foodSearchField.text!
                    
                }
                
            default: break
                
            }
        }
    }
    


}

