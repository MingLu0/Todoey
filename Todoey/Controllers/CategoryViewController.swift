//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Luo Ming on 24/07/18.
//  Copyright © 2018 Ming Luo. All rights reserved.
//

import UIKit
import CoreData 

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }

    //MARK:- TableView Datasource Methods (display the categories)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            
            let newCategory = Category(context:self.context)
            
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveCategories()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            print(alertTextField.text!)
            print("Now")
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Data Manipulation Methods (save, load to use CRUD)
    
    func saveCategories(){
        
        do{
            try context.save()
        } catch {
            print("Error saving the categories, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(with request : NSFetchRequest<Category>=Category.fetchRequest()){
        
        
        do {
            
            categoryArray = try context.fetch(request)
            print("category fetch request being called")
            
        } catch {
            
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
}
