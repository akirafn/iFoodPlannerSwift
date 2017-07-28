//
//  VCCozinhaLista.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/13/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import UIKit
import CoreData

class VCCozinhaItemCell : UITableViewCell{
    @IBOutlet weak var titulo: UILabel!
}

class VCCozinhaLista: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, VCReceitaBuscaDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgListaVazia: UILabel!
    
    var arrayIngrediente : [Item] = []
    var arrayReceitas : [Receita] = []
    
    func buscaReceitaPorIngrediente(listaIngrediente: [NSManagedObjectID : Item]) {
        arrayIngrediente.removeAll()
        arrayReceitas.removeAll()
        var listaAux : [Receita] = []
        
        for (key, value) in listaIngrediente {
            if value != nil{
                arrayIngrediente.append(value)
                let listaReceitas = value.receita as! Set<ItemReceita>
                
                if(arrayReceitas.count > 0){
                    listaAux.removeAll()
                    for itemReceita in listaReceitas {
                        if(arrayReceitas.contains(itemReceita.receita!)){
                            listaAux.append(itemReceita.receita!)
                        }
                    }
                    arrayReceitas.removeAll()
                    arrayReceitas = listaAux
                } else{
                    for itemDaReceita in listaReceitas {
                        arrayReceitas.append(itemDaReceita.receita!)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool){
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalheReceita" {
            let cell = sender as! VCCozinhaItemCell
            let indexPath = tableView.indexPath(for: cell)
            let receitaVC : VCReceitaNova = segue.destination as! VCReceitaNova
            receitaVC.carregaReceita(dadoReceita: arrayReceitas[(indexPath?.row)!])
        } else if segue.identifier == "buscaReceita" {
            let buscaVC : VCReceitaBusca = segue.destination as! VCReceitaBusca
            buscaVC.delegate = self
            buscaVC.arrayIngredientes.removeAll()
            for itemIngrediente in arrayIngrediente {
                buscaVC.arrayIngredientes[itemIngrediente.objectID] = itemIngrediente
            }
        }
    }
    
    @IBAction func limparBusca(_ sender: Any) {
        self.arrayIngrediente.removeAll()
        self.arrayReceitas.removeAll()
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nroReceitas = arrayReceitas.count
        
        if(nroReceitas > 0){
            self.tableView.isHidden = false
            self.msgListaVazia.isHidden = true
        } else{
            self.tableView.isHidden = true
            self.msgListaVazia.isHidden = false
        }
        
        
        return nroReceitas
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CozinhaItemCellIdentifier", for: indexPath) as! VCCozinhaItemCell
        
        let regReceita : Receita = arrayReceitas[indexPath.row]
        cell.titulo.text = regReceita.titulo
        
        return cell
    }
}
