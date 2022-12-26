//
//  ViewController.swift
//  HitList
//
//  Created by Иван on 26.12.22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Список"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try context.fetch(fetchRequest)
        } catch let error as NSError {
    print("CAN'T FETCH - \(error), \(error.userInfo)")
}
        
    }

    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Новое имя", message: "Добавьте новое имя", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text
            else { return }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) else { return }
        let person = NSManagedObject(entity: entity, insertInto: context)
        person.setValue(name, forKey: "name")
        do {
            try context.save()
            people.append(person)
        } catch let error as NSError {
            print("CAN'T SAVE - \(error), \(error.userInfo)")
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKey:"name") as? String
        
        return cell
    }
    
    
}

