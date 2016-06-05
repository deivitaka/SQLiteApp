//
//  ViewController.swift
//  SQLiteApp
//
//  Created by deivitaka on 3/21/16.
//
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    private var contacts = [Contact]()
    private var selectedContact: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        
        contacts = StephencelisDB.instance.getContacts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button functions
    
    @IBAction func addButtonClicked() {
        let name = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let address = addressTextField.text ?? ""
        
        if let id = StephencelisDB.instance.addContact(name, cphone: phone, caddress: address) {
            let contact = Contact(id: id, name: name, phone: phone, address: address)
            contacts.append(contact)
            contactsTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: contacts.count-1, inSection: 0)], withRowAnimation: .Fade)
        }
    }
    
    @IBAction func updateButtonClicked() {
        if selectedContact != nil {
            let id = contacts[selectedContact!].id!
            let contact = Contact(
                id: id,
                name: nameTextField.text ?? "",
                phone: phoneTextField.text ?? "",
                address: addressTextField.text ?? "")
            
            StephencelisDB.instance.updateContact(id, newContact: contact)
            
            contacts.removeAtIndex(selectedContact!)
            contacts.insert(contact, atIndex: selectedContact!)
            
            contactsTableView.reloadData()
        } else {
            print("No item selected")
        }
    }
    
    @IBAction func deleteButtonClicked() {
        if selectedContact != nil {
            StephencelisDB.instance.deleteContact(contacts[selectedContact!].id!)
            contacts.removeAtIndex(selectedContact!)
            contactsTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: selectedContact!, inSection: 0)], withRowAnimation: .Fade)
        } else {
        print("No item selected")
        }
    }

    // MARK: TableView functions
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        nameTextField.text = contacts[indexPath.row].name
        phoneTextField.text = contacts[indexPath.row].phone
        addressTextField.text = contacts[indexPath.row].address
        
        selectedContact = indexPath.row
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell")!
        var label: UILabel?
        label = cell.viewWithTag(1) as? UILabel // Name label
        label?.text = contacts[indexPath.row].name
        
        label = cell.viewWithTag(2) as? UILabel // Phone label
        label?.text = contacts[indexPath.row].phone
        
        return cell
    }
}

