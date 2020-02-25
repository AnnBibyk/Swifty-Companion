//
//  SearchViewController.swift
//  Swifty Companion
//
//  Created by Anna Bibyk on 22.02.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var user: User?
    var validProjects = [ProjectsUser]()
    
    @IBOutlet weak var loginTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        APIController.getToken()
    }
    
    func parseProjects()
    {
        if let projectArr = user?.projectsUsers
        {
            for project in projectArr
            {
                guard let slug = project.project.slug else { continue }
                //guard let name = project.project.name else { continue }
                if (project.project.parent_id == nil && !slug.hasPrefix("piscine-c-")) {
                    validProjects.append(project)
                }
            }
        }
        //print(validProjects)
    }

    @IBAction func searchButtonPressed(_ sender: Any) {
        
        if loginTextField.text == "" {
            return
        }
        guard let login = loginTextField.text?.lowercased() else { return }
        print(login)
        APIController.checkToken()
        APIController.getUser(login: login) { (data) in
            guard let user = data else { return }
            print(login)
            self.user = user
            self.parseProjects()
            
            self.performSegue(withIdentifier: "goToProfile", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProfileViewController
        vc.user = user
        vc.validProjects = validProjects
    }

}

