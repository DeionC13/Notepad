//
//  NoteViewController.swift
//  Notepad
//
//  Created by Deion caldwell on 1/19/23.
//

import UIKit
import CoreData

class NoteViewController: UIViewController, UITextViewDelegate {
    
    var selectedCategory : NoteCategory?
    
    var notes = [Note]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        notesEntered.delegate = self
        loadNotes()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
        loadNotes()
    }
    //MARK: - Data Manipulation Methods
    func updateUI(){
        
        if notesEntered.text! == "" {
            notesEntered.text = notes.last?.body
            
        } else {
            
            let newNote = Note(context: self.context)
            newNote.parentCategory = self.selectedCategory
            newNote.body = notesEntered.text!
            notes.append(newNote)
            notes.removeFirst()
            saveNotes()
            
            
        }
    }
    
    
    func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest()) {
        do {
           notes = try context.fetch(request)
            
        } catch {
            print("error loading notes, \(error)")
        }
        
    }
    
    
    func saveNotes() {
        do {
            try context.save()
        } catch {
            print("error saving notes context, \(error)")
        }
    }
    
    @IBOutlet weak var notesEntered: UITextView!
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        saveNotes()

        updateUI()
    }
}
