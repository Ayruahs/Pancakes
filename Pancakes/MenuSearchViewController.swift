//
//  ViewController.swift
//  Pancakes
//
//  Created by Shaurya Sinha on 26/05/17.
//  Copyright © 2017 Shaurya Sinha. All rights reserved.
//

import UIKit


class MenuSearchViewController: UIViewController {

    @IBAction func keyboardSearch(_ sender: Any) {
        performSegue(withIdentifier: "Show Table", sender: self)
    }
    @IBOutlet weak var foodSearchField: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    // Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier{
            case "Show Table":
                if let destNavController = segue.destination as? TableViewController{
                    //let targetController = destNavController.view as! TableViewController
                    
                    let searchTerm = foodSearchField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "_")
                    
                    destNavController.URLString = "https://api.hfs.purdue.edu/menus/v2/items/searchUpcoming/" + searchTerm
                }
                
            default: break
                
            }
        }
    }
    


}

