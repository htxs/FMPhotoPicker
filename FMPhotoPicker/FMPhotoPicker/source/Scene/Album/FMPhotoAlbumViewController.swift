//
//  FMPhotoAlbumViewController.swift
//  FMPhotoPicker
//
//  Created by Jie Tian on 2020/3/26.
//  Copyright © 2020 Tribal Media House. All rights reserved.
//

import UIKit
import Photos

class FMPhotoAlbumViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
         return false
    }
    
    var didSelectAlbum: ((FMAlbum) -> Void)?
    var albums = [FMAlbum]()
    let albumsManager: FMAlbumsManager
    
    let tableView = UITableView()
    
    required init(albumsManager: FMAlbumsManager) {
        self.albumsManager = albumsManager
        super.init(nibName: nil, bundle: nil)
        title = albumsManager.config.strings["albums_title"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: albumsManager.config.strings["picker_button_cancel"],
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(close))
        setUpTableView()
        fetchAlbumsInBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func fetchAlbumsInBackground() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.albums = self.albumsManager.fetchAlbums()
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpTableView() {
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView();
        let reuseCellNib = UINib(nibName: String(describing: FMAlbumCell.self), bundle: Bundle(for: self.classForCoder))
        tableView.register(reuseCellNib, forCellReuseIdentifier: String(describing: FMAlbumCell.self))
    }
}

extension FMPhotoAlbumViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albums[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FMAlbumCell.self), for: indexPath) as? FMAlbumCell {
            cell.thumbnail.backgroundColor = .gray
            cell.thumbnail.image = album.thumbnail
            cell.title.text = album.title
            cell.numberOfItems.text = "(\(album.numberOfItems))"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            return cell
        }
        return UITableViewCell()
    }
}

extension FMPhotoAlbumViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectAlbum?(albums[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

