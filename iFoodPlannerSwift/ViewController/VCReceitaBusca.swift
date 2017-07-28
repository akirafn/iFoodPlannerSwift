//
//  VCReceitaBusca.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/26/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import UIKit
import CoreData

class VCReceitaBuscaCell: UITableViewCell {
    @IBOutlet weak var nomeIngrediente: UILabel!
    @IBOutlet weak var checkIngrediente: UIImageView!
}

protocol VCReceitaBuscaDelegate {
    func buscaReceitaPorIngrediente(listaIngrediente: [NSManagedObjectID : Item])
}

class VCReceitaBusca: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var botaoBuscar: UIButton!
    
    let pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var frc : NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    var arrayIngredientes : [NSManagedObjectID : Item] = [:]
    var delegate : VCReceitaBuscaDelegate?
    

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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func realizarBusca(_ sender: Any) {
        let nroIngredientes = contarIngredientes()
        
        if nroIngredientes > 0 {
            let alertController = UIAlertController(title: "Sucesso", message: "Ingredientes adicionados com sucesso!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                self.delegate?.buscaReceitaPorIngrediente(listaIngrediente: self.arrayIngredientes)
                self.navigationController?.popViewController(animated: true)
                return
            })
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        } else{
            let alertController = UIAlertController(title: "Sucesso", message: "Nenhum ingrediente foi adicionado. Deseja prosseguir?", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Sim", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
                return
            })
            let cancelAction = UIAlertAction(title: "Nao", style: .cancel, handler: {
                (action: UIAlertAction!) -> Void in
            })
            
            alertController.addAction(alertAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return (frc.sections?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buscaReceitaIdentifier", for: indexPath) as! VCReceitaBuscaCell
        
        let itemIngrediente = frc.object(at: indexPath) as! Item
        cell.nomeIngrediente.text = itemIngrediente.nome
        cell.checkIngrediente.image = UIImage(named: "uncheckIcon")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = frc.object(at: indexPath) as! Item
        
        if arrayIngredientes[item.objectID] == nil {
            let currentCell = tableView.cellForRow(at: indexPath) as! VCReceitaBuscaCell
            currentCell.checkIngrediente.image = UIImage(named: "checkIcon")
            arrayIngredientes[item.objectID] = item
        } else{
            let currentCell = tableView.cellForRow(at: indexPath) as! VCReceitaBuscaCell
            currentCell.checkIngrediente.image = UIImage(named: "uncheckIcon")
            arrayIngredientes[item.objectID] = nil
        }
    }
    
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
    
    func  contarIngredientes() -> Int {
        var nroIngredientes : Int = 0
        
        for (key, value) in arrayIngredientes {
            if(value != nil){
                nroIngredientes += 1
            }
        }
        
        return nroIngredientes
    }
}
