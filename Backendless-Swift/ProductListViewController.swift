//
//  ViewController.swift
//  Backendless-Swift
//
//  Created by Dmitry Kulakov on 24.01.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit
import Pods_Backendless_Swift

class ProductListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private let ProductsCellIdentifier = "ProductCell"
    private let ProductsDetailsSegueIdentifier = "ProductDetailsSegue"
    private var isLounched = false
    private var products = [Product]()
    private var productBackendlessCollection: BackendlessCollection?
    private let pageSize: NSNumber = 10
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        productBackendlessCollection = BackendlessCollection()
        requestProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isLounched {
            configureTableView()
            isLounched = true
        }
    }
    
    // MARK: TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsCellIdentifier, for: indexPath) as! ProductTableViewCell
        let product = products[indexPath.row]
        cell.configureCell(product: product)
        return cell
    }
    
    // MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.products[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as? ProductTableViewCell
        product.image = cell?.productImageView.image
        self.performSegue(withIdentifier: ProductsDetailsSegueIdentifier, sender: product)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ProductsDetailsSegueIdentifier {
            if let product = sender as? Product {
                let productDetailsVC = segue.destination as? ProductDetailsViewController
                productDetailsVC?.product = product
            }
        }
    }
        
    // MARK: Requests
    
    func requestProducts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let query = BackendlessDataQuery()
        query.queryOptions.pageSize = self.pageSize
        appDelegate.backendless?.persistenceService.of(Product.ofClass()).find(query, response: { [weak self]objectBackendlessCollection in
            guard let weakSelf = self else { return }
            guard let productBackendlessCollection = objectBackendlessCollection else { return }
            weakSelf.productBackendlessCollection = productBackendlessCollection
            weakSelf.products = productBackendlessCollection.getCurrentPage() as! [Product]
            weakSelf.tableView.tableFooterView?.isHidden = false
            weakSelf.tableView.reloadData()
        }, error: { fault in
            print("Server reported an error: \(fault)")
        })
    }
    
    func requestNextProducts() {
        self.productBackendlessCollection?.nextPageAsync({ [weak self] objectBackendlessCollection in
            guard let weakSelf = self else { return }
            guard let productBackendlessCollection = objectBackendlessCollection else { return }
            weakSelf.productBackendlessCollection = productBackendlessCollection
            let productArray = productBackendlessCollection.getCurrentPage() as! [Product]
            weakSelf.products.append(contentsOf: productArray)
            weakSelf.tableView.reloadData()
            if productBackendlessCollection.totalObjects.intValue <= weakSelf.products.count {
                weakSelf.tableView.tableFooterView?.isHidden = true
                weakSelf.tableView.tableFooterView = UIView(frame: CGRect.zero)
            }
        }, error: { fault in
            print("Server reported an error: \(fault)")
        })
    }
    
    // MARK: Configure Elements
    
    func configureFooterView() {
        let loadMoreView = UIView(frame: CGRect(x:0,y:0,width:self.view.frame.size.width,height:60))
        self.tableView.tableFooterView = loadMoreView
        let loadMoreButton = UIButton()
        loadMoreButton.isUserInteractionEnabled = true
        loadMoreButton.backgroundColor = .white
        loadMoreButton.setTitleColor(UIColor.black, for: .normal)
        loadMoreButton.frame = CGRect(x:0,y:0,width:160,height:44)
        loadMoreButton.addTarget(self, action:#selector(loadMoreButtonPressed), for: .touchUpInside)
        loadMoreButton.setTitle("Load More", for: .normal)
        loadMoreButton.layer.cornerRadius = 10
        loadMoreButton.layer.borderWidth = 1
        loadMoreButton.layer.borderColor = UIColor.black.cgColor
        loadMoreView.addSubview(loadMoreButton)
        loadMoreButton.center = loadMoreView.center
        self.tableView.tableFooterView?.isHidden = true
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.configureFooterView()
        self.tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: ProductsCellIdentifier)
    }
    
    // MARK: Actions
    
    func loadMoreButtonPressed() {
        requestNextProducts()
    }
}

