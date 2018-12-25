//
//  ViewController.swift
//  ARBundView
//
//  Created by David Peng on 2018/12/20.
//  Copyright © 2018 David Peng. All rights reserved.
//

import UIKit

var builds = [Building]()

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load building table
        loadTableBuildings()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return builds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }

        // Fetches the appropriate building for the data source layout.
        let build = builds[indexPath.row]
        
        // Configure the cell...
        cell.BuildingName.text = build.name
        cell.BuildingIcon.image = build.photo
        
        return cell
    }
 
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        super.prepare(for: segue, sender: sender)
        
        // Pass the selected object to the new view controller.
        switch(segue.identifier ?? "") {
        case "ShowDetail":
            guard let ShowWebViewController = segue.destination as? WebViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedBuildCell = sender as? TableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedBuildCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedBuild = builds[indexPath.row]
            ShowWebViewController.build = selectedBuild
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    // MARK: Private Methods
    private func loadTableBuildings() {
        if let fileUrl = Bundle.main.url(forResource: "BuildingList", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: fileUrl)
                let buildPList = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as![[String: String]]
                
                for build1 in buildPList {
                    let name1 = build1["Name"]
                    let photo1 = UIImage(named: build1["Photo"]!)
                    let URLstring = "https://en.m.wikipedia.org/wiki/" + build1["URL"]!
                    guard let Sbuild = Building(name: name1!, photo: photo1, url: URL(string: URLstring)!) else {
                        fatalError("Unable to instantiate building. \(name1 as String?)")
                    }
                    Sbuild.searchAddress = (build1["SearchAddress"])
                    
                    builds += [Sbuild]
                }
            } catch {
                fatalError("BuildingList.plist process failure.")
            }
        }
    }
}

