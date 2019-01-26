//
//  TodoListViewController.swift
//  TODO
//
//  Created by Rohlf W on 2019/1/26.
//  Copyright © 2019 Rohlf W. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        let newItem = Item()
//        newItem.title = "购买水杯😴"
//        itemArray.append(newItem)
//        let newItem1 = Item()
//        newItem1.title = "吃药💊"
//        itemArray.append(newItem1)
//        let newItem2 = Item()
//        newItem2.title = "修改密码🎈"
//        itemArray.append(newItem2)
        loadItems()
    
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
//            itemArray = items
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done == false {
            cell.accessoryType = .none
        }else{
            cell.accessoryType = .checkmark
        }

        return cell
    }


    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        
        
        let alert = UIAlertController(title: "添加一个TODO项目", message: "", preferredStyle: .alert)
        
        alert.addTextField{
            (alertTextFiled) in
            alertTextFiled.placeholder = "创建一个新项目..."
            textFiled = alertTextFiled
        }
        let action = UIAlertAction(title: "添加项目", style: .default, handler: { (action) in
            //print("Success")
            let newItem = Item()
            newItem.title = textFiled.text!
            
            self.itemArray.append(newItem)
            self.saveItems()
            
            self.tableView.reloadData()
            })
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
    
}
    
    
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.datafilePath!)
            
        }
        catch{
            print("Falled in encoding ...")
        }
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: self.datafilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("解码错误")
            }
        }
    }
    
    
}
