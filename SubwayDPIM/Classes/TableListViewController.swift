//
//  TableListViewController.swift
//  SubwayDPIM
//
//  Created by PST on 2020/02/04.
//  Copyright © 2020 PST. All rights reserved.
//

import UIKit

class TableListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var stations = [SubwayInfomation]()
    var filteredStations = [SubwayInfomation]()
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var tabGestureRecognizer: UITapGestureRecognizer?
    @IBOutlet weak var panGestureRecognizer: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar?.placeholder = "역이름을 입력하세요"
        searchBar?.delegate = self
        tabGestureRecognizer?.delegate = self
        tabGestureRecognizer?.cancelsTouchesInView = false
        panGestureRecognizer?.delegate = self
        panGestureRecognizer?.cancelsTouchesInView = false
    }
    
    func isFiltering() -> Bool {
        let empty = searchBar?.text?.isEmpty ?? true
        return !empty
    }
    
    // DetailView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! StationCell
        
        if let index = cell.index {
            
            let item = stations[index]
            
            let viewController = segue.destination as! DetailInfomationViewController
            viewController.station = item
        }
    }
        
    // TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredStations.count
        }
        
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationList", for: indexPath) as! StationCell
        let item: SubwayInfomation
        
        if isFiltering() {
            item = filteredStations[indexPath.row]
        }
        else {
            item = stations[indexPath.row]
        }
        
        cell.index = indexPath.row
        
        cell.lineImageView?.image = UIImage(named: item.imageName ?? "0")
        cell.stationNameLabel?.text = item.name
        cell.wheelChairLabel?.text = item.wheelChair
        cell.elevatorLabel?.text = item.elevator
        
        return cell
    }
}

class StationCell: UITableViewCell {
    
    var index: Int?
    
    @IBOutlet weak var lineImageView: UIImageView?
    @IBOutlet weak var stationNameLabel: UILabel?
    @IBOutlet weak var wheelChairLabel: UILabel?
    @IBOutlet weak var elevatorLabel: UILabel?
}

extension TableListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredStations = stations.filter( { (station : SubwayInfomation) -> Bool in
            return (station.name?.lowercased().contains(searchText.lowercased()) ?? true)
        })
        
        tableView?.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView?.reloadData()
    }
}

extension TableListViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        self.view.endEditing(true)
    }
}
