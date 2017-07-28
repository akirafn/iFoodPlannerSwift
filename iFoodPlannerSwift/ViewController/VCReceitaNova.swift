//
//  VCReceitaNova.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/17/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import UIKit
import CoreData

class VCReceitaIngredienteCell: UITableViewCell {
    @IBOutlet weak var nomeIngrediente: UILabel!
}

class VCReceitaNova: UIViewController, UITableViewDataSource, UITableViewDelegate, VCIngredienteListaDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtPreparo: UITextView!
    @IBOutlet weak var adicionarIngrediente: UIButton!
    @IBOutlet weak var botaoSalvarReceita: UIButton!
    
    let pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var arrayIngredientes: [Item] = []
    var detalheReceita : Receita? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if detalheReceita != nil {
            txtTitulo.text = detalheReceita?.titulo
            txtTitulo.isUserInteractionEnabled = false
            txtPreparo.text = detalheReceita?.procedimento
            txtPreparo.isUserInteractionEnabled = false
            adicionarIngrediente.isHidden = true
            botaoSalvarReceita.isHidden = true
        } else{
            txtTitulo.isUserInteractionEnabled = true
            txtPreparo.isUserInteractionEnabled = true
            adicionarIngrediente.isHidden = false
            botaoSalvarReceita.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecaoIngredientes" {
            let VCDestino = segue.destination as! VCIngredienteLista
            VCDestino.delegate = self
            VCDestino.listaItemsReceita.removeAll()
            for ingrediente in arrayIngredientes {
                VCDestino.listaItemsReceita[ingrediente.objectID] = ingrediente
            }
        }
    }
    
    func carregaReceita(dadoReceita : Receita) {
        detalheReceita = dadoReceita
        arrayIngredientes.removeAll()
        let listaIngredienteReceita = dadoReceita.ingrediente as! Set<ItemReceita>
        for itemIngredienteReceita in listaIngredienteReceita {
            arrayIngredientes.append(itemIngredienteReceita.ingrediente!)
        }
    }
    
    func carregaListaIngredientes(listaIngredientes: [NSManagedObjectID : Item]) {
        arrayIngredientes.removeAll()
        for (key, value) in listaIngredientes {
            if(value != nil){
                arrayIngredientes.append(value)
            }
        }
        
        tableView.reloadData()
    }
    
    @IBAction func salvarReceita(_ sender: Any) {
        if((txtTitulo.text?.characters.count)! > 0 && txtPreparo.text.characters.count > 0 && arrayIngredientes.count > 0){
            
            if detalheReceita != nil {
                detalheReceita?.titulo = txtTitulo.text
                detalheReceita?.procedimento = txtPreparo.text
            } else{
                let receitaDescription = NSEntityDescription.entity(forEntityName: "Receita", in: pc)
                let ingredienteDescription = NSEntityDescription.entity(forEntityName: "ItemReceita", in: pc)
                let receitaItem = Receita(entity: receitaDescription!, insertInto: pc)
                
                receitaItem.titulo = txtTitulo.text
                receitaItem.procedimento = txtPreparo.text
                
                for ingredienteParaReceita in arrayIngredientes {
                    let ingredienteItem = ItemReceita(entity: ingredienteDescription!, insertInto: pc)
                    ingredienteItem.receita = receitaItem
                    ingredienteItem.ingrediente = ingredienteParaReceita
                    ingredienteItem.quatidade = 1
                }
            }
            
            do{
                try pc.save()
            } catch{
                print(error)
            }
            
            let alertController = UIAlertController(title: "Sucesso", message: "Receita salva com sucesso!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
                return
            })
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        } else if(arrayIngredientes.count == 0){
            let alertController = UIAlertController(title: "Alerta", message: "Nao ha ingredientes adicionados!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
            })
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: "Alerta", message: "Campos de receitas nao estao devidamente preenchidos!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
            })
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayIngredientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceitaIngredienteIdentifier", for: indexPath) as! VCReceitaIngredienteCell
        
        let receitaItem = arrayIngredientes[indexPath.row]
        cell.nomeIngrediente.text = receitaItem.nome
        
        return cell
    }
}
