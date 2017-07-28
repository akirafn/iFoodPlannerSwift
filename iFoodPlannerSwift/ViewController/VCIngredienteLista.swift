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

protocol VCIngredienteListaDelegate {
    func carregaListaIngredientes(listaIngredientes : [NSManagedObjectID : Item])
}

class VCIngredienteLista: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var botaoSalvar: UIButton!
    var delegate: VCIngredienteListaDelegate?
    
    let pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext    
    var frc : NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    var listaItemsReceita: [NSManagedObjectID: Item] = [:]
    
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
        if let flagItem = listaItemsReceita[item.objectID]{
            if(flagItem != nil){
                cell.checkedIcon.image = UIImage(named: "checkIcon")
            } else{
                cell.checkedIcon.image = UIImage(named: "uncheckIcon")
            }
        } else{
            cell.checkedIcon.image = UIImage(named: "uncheckIcon")
            listaItemsReceita[item.objectID] = nil
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = frc.object(at: indexPath) as! Item
        
        if listaItemsReceita[item.objectID] == nil {
            let currentCell = tableView.cellForRow(at: indexPath) as! VCIngredienteListaItem
            currentCell.checkedIcon.image = UIImage(named: "checkIcon")
            listaItemsReceita[item.objectID] = item
        } else{
            let currentCell = tableView.cellForRow(at: indexPath) as! VCIngredienteListaItem
            currentCell.checkedIcon.image = UIImage(named: "uncheckIcon")
            listaItemsReceita[item.objectID] = nil
        }
    }
    
    /*
     Actions
     */
    @IBAction func salvarListaIngredientes(_ sender: UIButton) {
        let nroItens = contarIngredientes()
        
        if(nroItens > 0){
            let alertController = UIAlertController(title: "Sucesso", message: "Ingredientes adicionados com sucesso!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                self.delegate?.carregaListaIngredientes(listaIngredientes: self.listaItemsReceita)
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
    
    func  contarIngredientes() -> Int {
        var nroIngredientes : Int = 0
        
        for (key, value) in listaItemsReceita {
            if(value != nil){
                nroIngredientes += 1
            }
        }
        
        return nroIngredientes
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
