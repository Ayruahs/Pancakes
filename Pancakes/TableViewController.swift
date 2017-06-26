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
    var preveName = String()
    var foodDate: String = String()
    var foodLocation: String = String()
    
    var relevantFoodFound = false
    
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
        
        preveName = eName
        eName = elementName
        
        if elementName == "Name" {
            if preveName == "ID"{
                relevantFoodFound = true
                foodName = String()
                //foodDate = String()
                foodLocation = String()
            }
        }
        if elementName == "Location" {
            relevantFoodFound = true
            foodLocation = String()
        }
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if relevantFoodFound{
            let food = Food()
            
            if elementName == "Name" {
                if preveName == "ID"{
                    food.foodName = foodName
                    //food.foodDate = foodDate
                }
            }
            if elementName == "Location" {
                food.foodLocation = foodLocation
            }
            
            foods.append(food)
        }
        relevantFoodFound = false
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if eName == "Name"{
            if preveName == "ID"{
                foodName += string
            }
        }
        if eName == "Location"{
            foodLocation = string
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath)
        
        if foods.count > 0{
            let food = foods[indexPath.row]
    
            cell.textLabel?.text = food.foodName
        
            cell.detailTextLabel?.text = "At " + food.foodLocation
        
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
