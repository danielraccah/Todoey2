//
//  CategoryTableViewController.swift
//  Todoey2
//
//  Created by Daniel Raccah on 20/02/18.
//  Copyright © 2018 Daniel Raccah. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    loadCategories()
       
    }
    
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
        
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK: Data Manipulation Methods
    func saveCategories(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
       
        tableView.reloadData()
        
        
    }
    
    
    //MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //cosa succede se premo il pulsante ADD
            
            
            let newCategory = Category() //Salvataggio
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
            
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add New Category Name"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
