//
//  TableViewController.swift
//  Todoey
//
//  Created by Roro on 5/6/22.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework
//import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
//    Results is an auto-updating container type in Realm returned from object queries.
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }

//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            
        
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    func save(category: Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
             print("Error saving category \(error)")
        }
//                self.defaults.set(self.itemArray, forKey : "ToDoListArray")
            self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//           categories = try context.fetch(request)
//        } catch {
//            print("error fetching data \(error)")
//        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
               do {
                   try self.realm.write {
                       self.realm.delete(categoryForDeletion)
                   }
               } catch {
                   print("Error deleting category, \(error)")
               }
//                tableView.reloadData()
           }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add ", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
//            self.categories.append(newCategory)
            self.save(category: newCategory)
            }
            alert.addAction(action)
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
//            print(alertTextField.text)
            textField = alertTextField
        }
        present(alert, animated: true ,completion: nil)
    }
}

