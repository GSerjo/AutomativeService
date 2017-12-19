//
//  ViewController.swift
//  AutomativeService
//
//  Created by Sergey Morenko on 12/11/17.
//  Copyright © 2017 Sergey Morenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var _issues = [IssueEntity]()
    var _selectedIssue: IssueEntity?
    let _repository = IssueRepository.instance
    let _dateFormatter = DateFormatter()
    
    @IBOutlet weak var _tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _dateFormatter.dateStyle = .long
        _dateFormatter.timeStyle = .none
        
        try! DataStore.instance.create()
        
        _issues = _repository.getAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showIssue" {
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.viewControllers[0] as! IssueViewController
            controller.setup(issue: _selectedIssue, onComplete: onSaveIssue)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issueCellId", for: indexPath)
        let issue = _issues[indexPath.row]
        cell.textLabel?.text = issue.vehicleMake
        cell.detailTextLabel?.text =  _dateFormatter.string(for: issue.estimate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        _selectedIssue = _issues[indexPath.item]
        performSegue(withIdentifier: "showIssue", sender: nil)
    }
    
    @IBAction func onAddClicked(_ sender: Any) {
        _selectedIssue = nil
        performSegue(withIdentifier: "showIssue", sender: nil)
    }
    
    private func onSaveIssue(issue: IssueEntity) -> Void {
        _repository.saveOrUpdate(entity: issue)
        _issues.append(issue)
        _tableView.reloadData()
    }
}

