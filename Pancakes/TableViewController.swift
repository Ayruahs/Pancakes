//
//  TableViewController.swift
//  Pancakes
//
//  Created by Shaurya Sinha on 10/06/17.
//  Copyright © 2017 Shaurya Sinha. All rights reserved.
//

import UIKit


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
        //self.searchResults.reloadData()
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath)
        
        if foods.count > 0{
            let food = foods[indexPath.row]
    
            cell.textLabel?.text = food.foodName
            
            let index = food.foodDate.index(food.foodDate.startIndex, offsetBy: 10)

            cell.detailTextLabel?.text = "At " + food.foodLocation + " for " + food.foodMeal + " on " + food.foodDate.substring(to: index)
        
            //cell.detailTextLabel?.text = "LOOOGABAROOGA"
        } else{
            cell.textLabel?.text = "No results :("
            cell.detailTextLabel?.text = "Try searching again"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(foods.count)
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
