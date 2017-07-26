//
//  CustomTableViewCell.swift
//  Pancakes
//
//  Created by Shaurya Sinha on 25/07/17.
//  Copyright © 2017 Shaurya Sinha. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var reminderButton: UIButton!
    
    
    /*@IBAction func sendReminder(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Set reminder for this food item?", preferredStyle: UIAlertControllerStyle.alert)
        
        //Add actions
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:  {
            
            (action:UIAlertAction!) in print("You have set a reminder.")
            
            }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)
    }*/
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
