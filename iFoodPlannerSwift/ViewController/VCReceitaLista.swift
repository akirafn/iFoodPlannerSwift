//
//  VCReceitaLista.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/13/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import UIKit
import CoreData

class VCReceitaItemCell : UITableViewCell{
    @IBOutlet weak var titulo: UILabel!
}

class VCReceitaLista: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelSemReceitas: UILabel!
    
    let pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var frc : NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    
    func fetchRequests() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Receita")
        let sorter = NSSortDescriptor(key: "titulo", ascending: true)
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarReceita" {
            let cell = sender as! VCReceitaItemCell
            let indexPath = tableView.indexPath(for: cell)
            let receitaVC : VCReceitaNova = segue.destination as! VCReceitaNova
            let receitaItem : Receita = frc.object(at: indexPath!) as! Receita
            receitaVC.carregaReceita(dadoReceita: receitaItem)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let nroSessoes = frc.sections?.count
        return nroSessoes!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nroReceitas = frc.sections?[section].numberOfObjects
        
        if((nroReceitas!) > 0){
            self.labelSemReceitas.isHidden = true
            self.tableView.isHidden = false
        } else{
            self.labelSemReceitas.isHidden = false
            self.tableView.isHidden = true
        }
        
        
        return nroReceitas!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceitaItemCellIdentifier", for: indexPath) as! VCReceitaItemCell
        let item = frc.object(at: indexPath) as! Receita
        
        cell.titulo.text = item.titulo
        
        return cell
    }
}
