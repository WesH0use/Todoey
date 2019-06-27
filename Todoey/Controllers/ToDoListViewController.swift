//
//  ViewController.swift
//  Todoey
//
//  Created by Wesley House on 6/18/19.
//  Copyright © 2019 Wesley House. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.rowHeight = 70.0
      }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colourHex = selectedCategory?.randomColor {
            
            title = selectedCategory?.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            
            navBar.barTintColor = UIColor(hexString: colourHex)
            navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn:navBar.barTintColor!, isFlat:true)
            searchBar.barTintColor = UIColor(hexString: colourHex)
            
        }
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        if let colour = UIColor(hexString: selectedCategory?.randomColor ?? "1D9BF6")!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:colour, isFlat:true)
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
            }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
    
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        }
                } catch {
                        print("Error saving new items, \(error)")
                    }
                }
            self.tableView.reloadData()
            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            // Create placeholder text in the UIAlert
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        }
    
        
    
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    
}


//MARK - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

