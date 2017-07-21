//
//  VCIngredienteLista.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/17/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import UIKit
import CoreData

class VCIngredienteListaItem: UITableViewCell {
    @IBOutlet weak var nomeIngrediente: UILabel!
    @IBOutlet weak var checkedIcon: UIImageView!
}

class VCIngredienteLista: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var botaoSalvar: UIButton!
    
    let pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext    
    var frc : NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    var listaItemsReceita: [Int: Bool] = [:]
    
    func fetchRequests() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let sorter = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sorter]
        return fetchRequest
    }
    
    func getFRC() -> NSFetchedResultsController<NSFetchRequestResult> {
        frc = NSFetchedResultsController(fetchRequest : fetchRequests(), managedObjectContext: pc, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frc = getFRC()
        frc.delegate = self
        
        do{
            try frc.performFetch()
        } catch{
            print(error)
            return
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        frc = getFRC()
        frc.delegate = self
        
        do{
            try frc.performFetch()
        } catch{
            print(error)
            return
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Tableview Delegate
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        let nroSessoes = frc.sections?.count
        return nroSessoes!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nroIngrdientes = frc.sections?[section].numberOfObjects
        
        if((nroIngrdientes!) > 0){
            self.tableView.isHidden = false
        } else{
            self.tableView.isHidden = true
        }
        
        
        return nroIngrdientes!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredienteListaItemCellIdentifier", for: indexPath) as! VCIngredienteListaItem
        let item = frc.object(at: indexPath) as! Item
        
        cell.nomeIngrediente.text = item.nome
        cell.checkedIcon.image = UIImage(named: "uncheckIcon")
        listaItemsReceita[item.itemId as! Int] = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    /*
     Actions
     */
    @IBAction func salvarListaIngredientes(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
