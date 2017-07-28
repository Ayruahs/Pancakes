//
//  TableViewController.swift
//  Pancakes
//
//  Created by Shaurya Sinha on 10/06/17.
//  Copyright © 2017 Shaurya Sinha. All rights reserved.
//

import UIKit
import UserNotifications

class TableViewController: UITableViewController, XMLParserDelegate {
    
    var foods: [Food] = []
    var foodName = String()
    var eName: String = String()
    var foodMeal: String = String()
    var foodDate: String = String()
    var foodLocation: String = String()
    
    var nameOfFood = String()
    
    var weAreInsideName = false
    var weAreInsideID = false
    
    var nameOfCurrentElement = String()
    
    var URLString: String = String()
    
    
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    @IBOutlet var searchResults: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let searchURL = URL(string: URLString)!
         
        var request = URLRequest(url: searchURL)
        request.setValue("application/xml", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
         
        let queue:OperationQueue = OperationQueue()
         
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) {
        (response, data, error) -> Void in
        let xmlParser = XMLParser(data: data!)
        xmlParser.delegate = self
        xmlParser.parse()
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
 
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        eName = elementName
    
        if elementName == "Allergen"{
            weAreInsideID = false
            nameOfCurrentElement = "Allergen"
        }
        
        if elementName == "ID"{
            weAreInsideID = true
        }
        if weAreInsideID{
            if elementName == "Name"{
                nameOfCurrentElement = "Name"
                weAreInsideName = true
                weAreInsideID = false
            }
        }
        
        
        if elementName == "Location"{
            nameOfCurrentElement = "Location"
        }
        if elementName == "Date"{
            nameOfCurrentElement = "Date"
        }
        if elementName == "Meal"{
            nameOfCurrentElement = "Meal"
        }
        
        
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if weAreInsideName{
            let food = Food()
            if elementName == "Name"{
                nameOfCurrentElement = ""
            }
            if elementName == "Location"{
                nameOfCurrentElement = ""
            }
            if elementName == "Date"{
                nameOfCurrentElement = ""
            }
            if elementName == "Meal"{
                food.foodName = foodName
                food.foodDate = foodDate
                food.foodLocation = foodLocation
                food.foodMeal = foodMeal
                nameOfCurrentElement = ""
                foods.append(food)
            }
        }
        
        if elementName == "ItemSchedule"{
            weAreInsideName = false
            
        }
        
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if nameOfCurrentElement == "Name"{
            nameOfFood = string
        }
        
        if nameOfCurrentElement == "Location"{
            foodLocation = string
        }
        if nameOfCurrentElement == "Date"{
            foodDate = string
        }
        if nameOfCurrentElement == "Meal"{
            foodName = nameOfFood
            foodMeal = string
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser){
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        }
        )
    }
    
    //override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //print("Button Pressed")
    //}
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath)
        
        if foods.count > 0{
            let food = foods[indexPath.row]
    
            cell.textLabel?.text = food.foodName
            
            let index = food.foodDate.index(food.foodDate.startIndex, offsetBy: 10)

            cell.detailTextLabel?.text = "At " + food.foodLocation + " for " + food.foodMeal + " on " + food.foodDate.substring(to: index)
        
        } else{
            cell.textLabel?.text = "No results :("
            cell.detailTextLabel?.text = "Try searching again"
        }
        
        /*
        let track_Button = UIButton()
        track_Button.setTitle("Track", for: .normal)
        track_Button.setTitleColor(UIColor.blue, for: .normal)
        track_Button.frame = CGRect(x: 50, y: 50, width: 100, height: 40)
        track_Button.backgroundColor = UIColor.gray
        track_Button.addTarget(self, action: Selector("track_Button_Pressed:"), for: .touchUpInside)
        cell.addSubview(track_Button)
        */
        //cell.accessoryType = .disclosureIndicator
        
        return cell
    }*/
    /*
    func track_Button_Pressed(sender: UIButton!) {
        
        // Track Functionality
        print("Add Track Functionality here")
    }
 */

    // !!!!!!!!!!!!! FOR THE CUSTOMTABLEVIEWCELL CLASS !!!!!!!!!!!!!
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        
        if foods.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath) as! CustomTableViewCell
            
            let food = foods[indexPath.row]
            
            cell.mainLabel?.text = food.foodName
            
            let index = food.foodDate.index(food.foodDate.startIndex, offsetBy: 10)
            
            cell.subtitleLabel?.text = "At " + food.foodLocation + " for " + food.foodMeal + " on " + food.foodDate.substring(to: index)
            
            cell.reminderButton.addTarget(self, action: #selector(addReminder(sender:)), for: .touchUpInside)
            
            cell.reminderButton.accessibilityHint = food.foodName + "|" + food.foodLocation + "|" + food.foodDate
            
            return cell
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath) 
            
            cell.textLabel?.text = "No results for chosen food"
            cell.detailTextLabel?.text = "Try searching for another food"
            
            return cell
        }
        

    }
    func addReminder(sender: UIButton!) {
        let alert = UIAlertController(title: nil, message: "Set reminder for this food item?", preferredStyle: UIAlertControllerStyle.alert)
        
        //Add actions
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:  {(action:UIAlertAction!) in
            
            //Figure what data you need to send back for creating alert text and notification
            
            self.initNotificationSetupCheck()
            
            var foodComponents = sender.accessibilityHint!.components(separatedBy: "|")
            
            let str: String = "You have set a reminder for " + foodComponents[0]
            
            print("\n\n\n\n", str)
            
            foodComponents[2] = foodComponents[2].replacingOccurrences(of: "T", with: " ")
            print(foodComponents)
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            dateFormatter.timeZone = TimeZone(identifier: "America/Indianapolis")
            
            
            var date = dateFormatter.date(from: foodComponents[2])
            
            let currentTimeinLocalTime = Date()
            let stringTime = dateFormatter.string(from: currentTimeinLocalTime)  //Date() as NSDate
            let now = dateFormatter.date(from: stringTime)
            
            if (date == nil){
                date = now
            }
            
            let formatter = DateComponentsFormatter()
            
            formatter.allowedUnits = [.minute]
            
            formatter.unitsStyle = .full
            
            let difference = formatter.string(from: now!, to: date!)!
            
            let differenceInMinutes = Int(difference.components(separatedBy: " ")[0].replacingOccurrences(of: ",", with: ""))!
            
            //Notification Set-up
            let notification = UNMutableNotificationContent()
            
            notification.title = "Your favorite food is coming up!"
            
            let notificationIdentifier = foodComponents[0] + foodComponents[1] + foodComponents[2]
            
            var notificationInterval = Int()
            
            if (differenceInMinutes == 0){
                notificationInterval = 3
                notification.body = "The API did not return a valid date for " + foodComponents[0]
            }
            else if (differenceInMinutes < 60){
                notificationInterval = differenceInMinutes * 60
                notification.body = foodComponents[0] + " at " + foodComponents[1] + " in \(differenceInMinutes) minutes."
            }else{
                notificationInterval = (differenceInMinutes * 60) - 3600
                notification.body = foodComponents[0] + " at " + foodComponents[1] + " in an hour."
            }
            
            print(notificationInterval/3600)
            
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(notificationInterval), repeats: false)
            
            let request = UNNotificationRequest(identifier: notificationIdentifier, content: notification, trigger: notificationTrigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        print("Table Row Pressed")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if foods.count == 0 {
            return 1
        } else{
            return foods.count
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    //}
    

}
