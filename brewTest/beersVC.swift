//
//  beersVC.swift
//  brewTest
//
//  Created by Alex Lauderdale on 12/17/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit
import BreweryDB





class beersVC: UITableViewController, UISearchBarDelegate{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //beer object
    var beers = [[String: String]]()
    
    //beer info holders
    var beerNames = [String]()
    var beerIdentifiers = [String]()
    var beerDescriptions = [String]()
    var beerLabelImages = [String]()
    
    // identify cell
    let cellReuseIdentifier = "cell"
    
    
    //tell if search is active or not
    var searchActive : Bool = false
    
    
    override func viewDidLoad() {
        
        // title at the top
        self.navigationItem.title = "Beer FInder"
        
        //loads the beers and builds the beers array
        self.getBeers(searchQuery: "ipa")
        
        
        //declare search bar
        searchBar.delegate = self
        
        //default
        super.viewDidLoad()
      
        
    }
    
    
    
    func clearArrays(){
        
        self.beerDescriptions.removeAll()
        self.beerLabelImages.removeAll()
        self.beerNames.removeAll()
        self.beers.removeAll()
        
    }
    
    
    
    func getBeers(searchQuery:String){
        
        
        //set search request from brewery DB
        let searchRequest = SearchRequest(params: [.searchTerm: searchQuery, .resultType: "beer", .withBreweries: "Y"])
        let requestMan = RequestManager<Search>(request: searchRequest)
        
        
        //get results
        requestMan?.fetch() { results in
            /// Access your array of beers here (or nil if nothing was found)
            
            //check for no results
            if results != nil {
                
                for result in results! {
                    
                    //append results info to empty arrays and set nil to empty string
                    self.beerNames.append((result.beer?.name ?? "")!)
                    
                    self.beerIdentifiers.append((result.beer?.identifier ?? "")!)
                    
                self.beerDescriptions.append((result.beer?.beerDescription ?? "")!)
                    
                    if let beerImage = result.beer?.imageURLSet?.icon?.absoluteString  {
                        self.beerLabelImages.append(beerImage)
                    } else {
                        //default image for nil image objects
                        self.beerLabelImages.append("https://s3.amazonaws.com/brewerydbapi/beer/xDFJlQ/upload_xMSIVO-icon.png")
                    }
                    
                    
                    
                }
                
            } else {
                
                print("Uh oh. Search probably returned a bunch of nothin")
                
            }
            
            
            //build an object from above arrays
            for i in 0 ..< self.beerNames.count {
                self.beers.append([
                    "name": self.beerNames[i],
                    "id" : self.beerIdentifiers[i],
                    "description" : self.beerDescriptions[i],
                    "imageUrl" : self.beerLabelImages[i]
                    ])
            }
            
            //refresh table to load results
            self.tableView.reloadData();
            
        }
        
        
        
    }
    
    
    
    
    func searchBarTextDidBeginEditing( _ searchBar: UISearchBar) {
        
        //show cancel button
        searchBar.setShowsCancelButton(true, animated: true)
        
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing( _ searchBar: UISearchBar) {
        
        //remove cancel button
        searchBar.setShowsCancelButton(false, animated: true)
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked( _ searchBar: UISearchBar) {
        
        //close search bar
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        
        //get the search term
        let searchTerm = searchBar.text! as String
        
        //clears out all the exosting search term arrays
        self.clearArrays()
        
        //loads the beers and builds the beers array
        self.getBeers(searchQuery: searchTerm)
    
        //dismiss the search bar when the button is clicked
        self.searchBar.endEditing(true)
        
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return beers.count
        
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:beerCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! beerCell

        // Fetch beer
        let beer = beers[indexPath.row]
        let name = beer["name"]
        let id = beer["id"]
        let imageUrl = beer["imageUrl"]
        
        //set up icon image URL and data
        let url = URL(string: imageUrl!)
        let data = try? Data(contentsOf: url!)
        
        // Configure Cell
        cell.beerLbl.text = name
        cell.breweryLbl.text = id
        cell.beerLabelImg.image = UIImage(data: data!)

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showBeer", sender: beers[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let guest = segue.destination as! beerVC
            guest.beerName = beers[selectedRow]["name"]!
            guest.beerDescription = beers[selectedRow]["description"]!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //Set custom row height
        return 90;
    }
    

    

}
