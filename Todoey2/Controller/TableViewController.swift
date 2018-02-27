//
//  ViewController.swift
//  Todoey2
//
//  Created by Daniel Raccah on 14/02/18.
//  Copyright © 2018 Daniel Raccah. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {

    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet{
           loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem", for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
        
            cell.textLabel?.text = toDoItems?[indexPath.row].title ?? "No Items Added Yet"

        }
        

        
        
        return cell
    }

    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done

                }
            } catch {
                print("Error saving done status, \(error)" )
            }
            
            
        }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
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
            
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
        
        
    //MARK: - Model Manipulation Methods
    

    func loadItems() {
       
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }

}

//MARK: - Search Bar Method

extension TableViewController : UISearchBarDelegate {

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
