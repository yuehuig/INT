//
//  HomeController.swift
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

import UIKit

class HomeController: BaseViewController {

    private let data: [HomeListModel] = [
        HomeListModel(name: "GCD", isOC: true),
        HomeListModel(name: "RunLoop", isOC: true),
        HomeListModel(name: "Block", isOC: true),
        HomeListModel(name: "EventResponder", isOC: true),
        HomeListModel(name: "Thread", isOC: true),
        HomeListModel(name: "Runtime", isOC: true),
        HomeListModel(name: "KeyWord", isOC: true),
        HomeListModel(name: "Memory", isOC: true),
        HomeListModel(name: "Associated", isOC: true),
        HomeListModel(name: "Category", isOC: true),
        HomeListModel(name: "Leaks", isOC: true),
        HomeListModel(name: "Lock", isOC: true),
        HomeListModel(name: "Observe", isOC: true),
        HomeListModel(name: "Notification", isOC: true),
        HomeListModel(name: "APM", isOC: true),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private lazy var tableView: UITableView = {
        let tableV = UITableView(frame: .zero, style: .grouped)
        tableV.backgroundColor = kC6Color
        tableV.contentInsetAdjustmentBehavior = .never
        tableV.showsVerticalScrollIndicator = false
        tableV.separatorStyle = .none
        return tableV
    }()
}

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = data[indexPath.row].name
        let isOC = data[indexPath.row].isOC
        guard let cls = vcCls(with: name, isOC: isOC) else {
            return
        }
        let vc = cls.init()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeController {
    override func setupUI() {
        super.setupUI()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = kC6Color
        tableView.frame = CGRect(x: 0, y: kStatusNavBarHeight, width: kScreenWidth, height: kScreenHeight - kStatusNavBarHeight)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
}

struct HomeListModel {
    var name: String
    var isOC: Bool
    init(name: String, isOC: Bool = false) {
        self.name = name
        self.isOC = isOC
    }
}

