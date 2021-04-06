//
//  GrocExtension.swift
//  GrocList
//
//  Created by Jatesh Kumar on 11/03/2021.
//

import UIKit
import Firebase

extension GrocViewController: UITableViewDataSource, UITableViewDelegate, DataAdditionDelegate, UITextFieldDelegate, GrocViewViewProtocol {
    
    /****TABLE VIEW**/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return grocData.count + 1
        } else {
            return doneData.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        sectionHeaderLabel.textAlignment = .center
        sectionHeaderLabel.textColor = .white
        sectionHeaderLabel.font = sectionHeaderLabel.font.withSize(30)
        if section == 0 {
            sectionHeaderLabel.text = "TODO"
        } else {
            sectionHeaderLabel.text = "DONE"
        }
        return sectionHeaderLabel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == grocData.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "GrocTextFieldCell", for: indexPath) as? GrocTextFieldCell else { return UITableViewCell()}
                cell.delegate = self
                cell.textFieldGroc.delegate = self
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "GrocNameCell", for: indexPath) as? GrocNameCell else { return UITableViewCell() }
                cell.configure(grocData: grocData[indexPath.row])
                guard let uid = grocData[indexPath.row].grocAssigneeID else { return UITableViewCell()}
                presenter?.getAssigneeName(uid: uid)
                cell.assigneeName.text = self.assigneeName
                return cell
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GrocNameCell", for: indexPath) as? GrocNameCell else {return UITableViewCell()}
            cell.configure(grocData: doneData[indexPath.row])
            guard let uid = doneData[indexPath.row].grocAssigneeID else { return UITableViewCell()}
            presenter?.getAssigneeName(uid: uid)
            cell.assigneeName.text = self.assigneeName
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row != grocData.count {
                getDescription(index: indexPath.row)
            }
        } else {
            showDescription(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            if indexPath.row != grocData.count {
                let deleteGrocAction = deleteGroc(indexPath, tableView: tableView)
                let updateGrocStatusAction = updateGrocStatus(indexPath, tableView: tableView)
                return UISwipeActionsConfiguration(actions: [deleteGrocAction, updateGrocStatusAction])
            }
            return UISwipeActionsConfiguration()
        } else {
            let deleteGrocAction = deleteGroc(indexPath, tableView: tableView)
            let updateGrocStatusAction = updateGrocStatus(indexPath, tableView: tableView)
            return UISwipeActionsConfiguration(actions: [deleteGrocAction, updateGrocStatusAction])
        }
    }
    
    func deleteGroc(_ indexPath: IndexPath, tableView: UITableView) -> UIContextualAction {
        guard let grocKey = self.grocKey else { return UIContextualAction() }
        let action = UIContextualAction(style: .destructive, title: "Delete") {(_, _, _)  in
            if indexPath.section == 0 {
                tableView.beginUpdates()
                guard let roomID = self.grocData[indexPath.row].roomID else { return }
                self.presenter?.deleteGroc(roomId: roomID, grocKey: grocKey)
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                guard let roomID = self.doneData[indexPath.row].roomID else { return }
                self.presenter?.deleteGroc(roomId: roomID, grocKey: grocKey)
                tableView.endUpdates()
            }
        }
        action.image = #imageLiteral(resourceName: "delete")
        action.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return action
    }
    
    /****ADD BUTTON CLICK - GROC FROM TEXTFIELD**/
    func didTap(data: String) {
        if !data.trimmingCharacters(in: .whitespaces).isEmpty {
            buttonActionAddGroc(data: data)
        } else {
            let alert = UIAlertController(title: "Empty Text Field", message: "Please Enter Some Groc Item", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /****Keyboard Return**/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /****MOVING BETWEEN Todo & DONE **/
    func updateGrocStatus(_ indexPath: IndexPath, tableView: UITableView) -> UIContextualAction {
        guard let grocKey = self.grocKey else { return UIContextualAction() }
        if indexPath.section == 0 {
            let action = UIContextualAction(style: .normal, title: "Mark As Done") {_, _, _ in
                if indexPath.row<self.grocData.count {
                    guard let currentUserId = self.grocData[indexPath.row].roomID else {return}
                    self.status = "0" // Moving To Done
                    self.presenter?.updateGrocStatus(roomId: currentUserId, status: self.status, grocKey: grocKey)
                }
            }
            action.image = #imageLiteral(resourceName: "Done")
            action.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            return action
        } else {
            let action = UIContextualAction(style: .normal, title: "Mark As Undone") {(_, _, _)  in
                if indexPath.row<self.doneData.count {
                    guard let currentUserId = self.doneData[indexPath.row].roomID else {return}
                    self.status = "1" // Moving to Todo
                    self.presenter?.updateGrocStatus(roomId: currentUserId, status: self.status, grocKey: grocKey)
                }
            }
            action.image = #imageLiteral(resourceName: "Undone")
            action.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            return action
        }
    }
    
    func getDescription(index: Int) {
        guard var description: String = grocData[index].grocDescription else { return }
        let alert = UIAlertController(title: grocData[index].grocName, message: "", preferredStyle: .alert)
        alert.addTextField {(textField: UITextField!) -> Void in
            textField.text = description
            textField.placeholder = "Enter Description"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ -> Void in
            description = (alert.textFields![0] as UITextField).text! as String
            guard let roomID = self.grocData[index].roomID else { return }
            guard let grocKey = self.grocKey else { return }
            self.presenter?.updateGrocDescription(roomId: roomID, description: description, grocKey: grocKey)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDescription(index: Int) {
        let description: String = doneData[index].grocDescription ?? "No Dscription"
        let alert = UIAlertController(title: doneData[index].grocName, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /**** PROTOCOL IMPLEMENTATION **/
    func setAssigneeName(name: String) {
        self.assigneeName = name
    }
    
    func error() {
        print("Some Error Occured")
    }
    
    func setupGrocView(grocList: [Grocs]) {
        let rawGrocData = grocList
        grocData = [Grocs]()
        doneData = [Grocs]()
        for groc in rawGrocData {
            if groc.status == "1" {
                grocData.append(groc)
            } else {
                doneData.append(groc)
            }
        }
        DispatchQueue.main.async {
            self.hideLoader()
            self.grocTableView.reloadData()
        }
    }
    func showLoader() {
        DispatchQueue.main.async {
            self.activityView = UIActivityIndicatorView(style: .large)
            self.activityView?.center = self.view.center
            self.grocTableView.addSubview(self.activityView!)
            self.activityView?.startAnimating()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            if self.activityView != nil {
                self.activityView?.stopAnimating()
            }
        }
    }
}
