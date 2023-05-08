//
//  ViewController.swift
//  JsonSerilazation-07-may
//
//  Created by Mac on 07/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var albumTableView: UITableView!
    var albums: [Album] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        xibConnect()
        fetchDataFromApi()
    }

    func xibConnect() {
        let uiNibName = UINib(nibName: "AlbumTableViewCell", bundle: nil)
        albumTableView.register(uiNibName, forCellReuseIdentifier: "AlbumTableViewCell")
    }
    
    func fetchDataFromApi() {
        let urlString = "https://jsonplaceholder.typicode.com/albums"
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let urlsession = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = urlsession.dataTask(with: request) {
            Data,response,error in
            let getJsonOnectOfArray = try! JSONSerialization.jsonObject(with: Data!) as! [[String:Any]]
            
            for jsonBind in getJsonOnectOfArray {
                let eachAlbumOject = jsonBind as! [String:Any]
                let albumUserId = eachAlbumOject["userId"] as!Int
                let albumId = eachAlbumOject["id"] as! Int
                let albumtitle = eachAlbumOject["title"] as! String
                let addData = (Album(userId: albumUserId, id: albumId, title: albumtitle))
                self.albums.append(addData)
                print("userid -- \(albumUserId) eachAlbumId -- \(albumId) title -- \(albumtitle)")
            }
            DispatchQueue.main.async {
                self.albumTableView.reloadData()
            }
        }
        
        dataTask.resume()
        
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumTableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell", for: indexPath) as! AlbumTableViewCell
        cell.backgroundColor = .yellow
        cell.userIdLbl.text = albums[indexPath.row].userId.description
        cell.idLbl.text = albums[indexPath.row].id.description
        cell.titleLbl.text = albums[indexPath.row].title
        return cell
    }
    
    
}
