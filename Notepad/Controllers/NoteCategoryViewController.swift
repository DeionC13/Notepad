//
//  ViewController.swift
//  Notepad
//
//  Created by Deion caldwell on 1/19/23.
//

import UIKit
import CoreData

class NoteCategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var noteCategories = [NoteCategory]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - Add New Notes
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "New Note", message: "Enter Note Title", preferredStyle: .alert)
        let action = UIAlertAction(title: "Create Note", style: .default) { action in
            
            let newCategory = NoteCategory(context: self.context)
            newCategory.name = textField.text!
            self.noteCategories.append(newCategory)
            self.saveCategories()
            self.performSegue(withIdentifier: "goToNote", sender: self)
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create title"
            textField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
//MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let noteCategory = noteCategories[indexPath.row]
        cell.textLabel?.text = noteCategory.name
        
        return cell
    }
  
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToNote", sender: self)

    }
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<NoteCategory> = NoteCategory.fetchRequest()) {
        do {
           noteCategories = try context.fetch(request)
        } catch {
            print("error loading notes, \(error)")
        }
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCategory = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteCategory])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            
            self.context.delete(self.noteCategories[indexPath.row])
            self.noteCategories.remove(at: indexPath.row)
            self.saveCategories()
        }
        return action
    }
}

