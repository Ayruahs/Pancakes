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
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let searchURL = URL(string: "https://www.w3schools.com/xml/simple.xml")!
        let searchURL = URL(string:"https://api.hfs.purdue.edu/menus/v2/items/searchUpcoming/pancake")!

        
        var request = URLRequest(url: searchURL)
        request.setValue("application/xml", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        let queue:OperationQueue = OperationQueue()
        /*
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request) {
            (data, response, error) -> Void in
            let xmlParser = XMLParser(data: data!)
            xmlParser.delegate = self
            xmlParser.parse()
            
            if !xmlParser.parse(){
                print("messed up parsing")
                print(xmlParser.parserError)
            }
            
        }.resume()
        */
        
        
            NSURLConnection.sendAsynchronousRequest(request, queue: queue) {
            (response, data, error) -> Void in
            let xmlParser = XMLParser(data: data!)
            xmlParser.delegate = self
            xmlParser.parse()
        }
        
    
    }
    

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath as IndexPath)
        
        let food = foods[indexPath.row]
        
        cell.textLabel?.text = food.foodName
        cell.detailTextLabel?.text = food.foodDate
        
        return cell
    }
    */
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        preveName = eName
        eName = elementName
        //print("previous element: "+preveName)
        if elementName == "Name" {
            if preveName == "ID"{
                foodName = String()
                //foodDate = String()
            }else{
                
            }
        }
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "Name" {
            
            if preveName == "ID"{

                let food = Food()
                food.foodName = foodName
                //food.foodDate = foodDate
            
                foods.append(food)
            }
        }
        
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        //if (!data.isEmpty) {
        //if eName == "Street" {
        //    foodName = string
        //}
        //} else if eName == "Date" {
        //    foodDate += string
        //    print(foodDate)
        //    }
        
        //}else{
        //    print("Data empty!!!")
        //}
        if eName == "Name"{
            if preveName == "ID"{

                foodName += string
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath) 
        
        
        let food = foods[indexPath.row]
    
        
        cell.textLabel?.text = food.foodName
        //cell.detailTextLabel?.text = food.foodDate
        cell.detailTextLabel?.text = "LOOOGABAROOGA"
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(foods.count)
        return foods.count
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
