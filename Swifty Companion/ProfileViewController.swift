//
//  ProfileViewController.swift
//  Swifty Companion
//
//  Created by Anna Bibyk on 22.02.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user: User!
    var validProjects = [ProjectsUser]()
    //var projects = []()
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var correctionPointsLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var projectsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userData = self.user else { print("No user info"); return }
        
//        for project in userData.projectsUsers {
//            print(project.project)
//        }
        
        
        configureHeader()
    }
    
    private func configureHeader() {
        setPhoto()
        nameLabel.text = user.displayname
        loginLabel.text = user.login
        walletLabel.text = "Wallet: \(user.wallet)"
        correctionPointsLabel.text = "Correction points: \(user.correctionPoint)"
        emailLabel.text = user.email
        mobileLabel.text = "Mobile: \(user.phone)"
        levelLabel.text = "\(user.cursusUsers[0].level)"
    }
    
    private func setPhoto() {
        let activityIndicator: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView()
            
            indicator.hidesWhenStopped = true
            indicator.color = .white
            indicator.translatesAutoresizingMaskIntoConstraints = false
            
            return indicator
        }()
        
        let imageStr = user.imageURL
        let imageUrl = URL(string: imageStr)
        
        profilePhotoImageView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: imageUrl!) {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    let image = UIImage(data: data)
                    self.profilePhotoImageView.image = image
                }
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return validProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.projectsTableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectsTableViewCell
//        for project in validProjects {
//            print(project.project.name)
//            print(project.status)
//            print(project.validated)
//            print("\n")
//        }
        //print(validProjects[indexPath.row].project.name)
        cell.projectNameLabel.text = validProjects[indexPath.row].project.name
        
        switch validProjects[indexPath.row].status {
        case .finished:
            if validProjects[indexPath.row].validated! {
                cell.markLabel.text = "\(validProjects[indexPath.row].finalMark ?? 0)"
                cell.markLabel.textColor = .systemGreen
            } else {
                cell.markLabel.text = "Failed"
                cell.markLabel.textColor = .systemRed
            }
        case .inProgress:
            cell.markLabel.text = "In process"
            cell.markLabel.textColor = .systemBlue
        case .parent:
            cell.markLabel.text = ""
        case .searchingAGroup:
            cell.markLabel.text = "Searching a group"
            cell.markLabel.textColor = .systemGray2
        case .creatingGroup:
            cell.markLabel.text = "Creating a group"
            cell.markLabel.textColor = .systemGray2
        }
        
        return cell
    }
    
    
}
