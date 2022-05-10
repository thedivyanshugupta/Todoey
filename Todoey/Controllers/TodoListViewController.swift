//
//  ViewController.swift
//  Todoey
//
//  Created by Roro on 4/22/22.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
//    let defaults = UserDefaults.standard
//    An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app.
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let realm = try! Realm()
    var toDoItems: Results<Item>?
    @IBOutlet weak var searchBar: UISearchBar!
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    when you use it you have to retrieve the entire list or load the entire list into memory before you can use any of the items or objects contained within the list.So again it's memory intensive to load up an entire table when you only want one or two items inside
    
    var selectedCategory: Category? {
        didSet{
//            everything that's between these curly braces is going to happen as soon as selected category gets set with a value.
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        if let colourHex = selectedCategory?.colour {
//        navigationController?.navigationBar.barTintColor = UIColor(hexString: colourHex)
        
//        loadItems()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colourHex = selectedCategory?.colour {
            title = selectedCategory?.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller doesnt exist")}
            
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.barTintColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                searchBar.barTintColor = navBarColour
//                print(colourHex)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Asks the data source for a cell to insert in a particular location of the table view.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(toDoItems!.count))) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
       
        return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status\(error)")
            }
            
        }
        tableView.reloadData()
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
//
//        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
          
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        }
                    }catch {
                        print("Error saving data \(error)")
                    }
                }
                self.tableView.reloadData()
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//            self.saveItems()
            }
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
//            print(alertTextField.text)
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
//
//    func saveItems() {
////            An object that encodes instances of data types to a property list.
//        do {
//           try context.save()
//        } catch {
//             print("Error saving context \(error)")
//        }
////                self.defaults.set(self.itemArray, forKey : "ToDoListArray")
//            self.tableView.reloadData()
//    }
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
////        request.predicate = compoundPredicate
//
//        do {
//           itemArray = try context.fetch(request)
//        } catch {
//            print("error fetching data \(error)")
//        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }
//    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//
//            do {
//            itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding item ,\(error)")
//            }
//
//        }
//    }
}
//
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true) 
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: predicate)
        tableView.reloadData()
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
//   An object that manages the execution of tasks serially or concurrently on your app's main thread or on a background thread.
            searchBar.resignFirstResponder()
            }
        }
    }
}
//
