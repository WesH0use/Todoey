//
//  ViewController.swift
//  Todoey
//
//  Created by Wesley House on 6/18/19.
//  Copyright © 2019 Wesley House. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    // new variable (itemArray) assigned to an array of Item objects from the Item.swift class
    // inherits the title property (set to an empty string) and the done property (set to false)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title  = "Find Mike"
        itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title  = "Wax"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title  = "Save world"
        itemArray.append(newItem3)
        // hard-coded the title property of three new item objects
        // appended each item object to itemArray
     
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        // Do any additional setup after loading the view.
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // tableview function that returns itemArray.count (an int) number of rows
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // what is "indexPath: IndexPath"
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        // ^ same as:
        //cell.accessoryType = item.done == true ? .checkmark : .none
        // and:
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // for the item at indexPath/row selected, make the .done property the opposite of what it currently is
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks "Add Item" on the UIAlert.
            
            let newItem = Item()
            newItem.title = textField.text!
            // new item object created throuhg the AlertAction function
            // property title set to the textfield entered by the user
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
            // append the new item to the initial itme array
            // save the new item as a user default for when the user returns, set the key as "ToDoListArray"
            // reload the Tableview to capture new information
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            // Create placeholder text in the UIAlert
            }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
}

