//
//  VCReceitaNova.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/17/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import UIKit

class VCReceitaIngredienteCell: UITableViewCell {
    @IBOutlet weak var nomeIngrediente: UILabel!
}

class VCReceitaNova: UIViewController, UITableViewDataSource, UITableViewDelegate, VCIngredienteListaDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtPreparo: UITextView!
    
    var arrayIngredientes: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VCDestino = segue.destination as! VCIngredienteLista
        VCDestino.delegate = self
    }
    
    func carregaListaIngredientes(listaIngredientes: [Int : Item]) {
        for (key, value) in listaIngredientes {
            if(value != nil){
                arrayIngredientes.append(value)
            }
        }
        
        tableView.reloadData()
    }
    
    @IBAction func salvarReceita(_ sender: Any) {
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
