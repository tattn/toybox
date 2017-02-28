//
//  ViewController.swift
//  Demo
//
//  Created by Tatsuya Tanaka on 2017/02/26.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit
import AsyncAwait

class UsersViewController: UITableViewController {

    private let dataStore: UserDataStore = UserDataStoreImpl()
    
    fileprivate var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        async {
            do {
                self.users = try await(self.dataStore.getUsers())
            } catch DataStoreError.unknown {
                fatalError(DataStoreError.unknown.localizedDescription)
            } catch { fatalError("ここには来ない") }

            main { self.tableView.reloadData() }
        }

//        async {
//            switch await2(self.dataStore.getUsersPromise()) {
//            case .success(let users):
//                self.users = users
//            case .failure(let error):
//                fatalError(error.localizedDescription)
//            }
//
//            main { self.tableView.reloadData() }
//        }
    }
}

// MARK:- tableview datasource / delegate
extension UsersViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}
