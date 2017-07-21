//
//  VCIngredienteNova.swift
//  iFoodPlannerSwift
//
//  Created by Flavio Akira Nakahara on 7/17/17.
//  Copyright © 2017 Flavio Akira Nakahara. All rights reserved.
//

import UIKit
import CoreData

class VCIngredienteNova: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var nomeIngrediente: UITextField!
    
    let pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func salvarIngrediente(_ sender: UIButton) {
        let ingredientName = nomeIngrediente.text

        if (ingredientName?.characters.count)! > 0 {
            saveIngredient(ingredientName: ingredientName!)
        } else{
            let alertController = UIAlertController(title: "Atencao", message: "Nome do ingrediente nao pode ser vazio", preferredStyle: .alert)
            let dismissButton = UIAlertAction(title: "OK", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                
            })
            alertController.addAction(dismissButton)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
    func saveIngredient(ingredientName: String) {
        let ingredientDescription = NSEntityDescription.entity(forEntityName: "Item", in: pc)
        let ingredientItem = Item(entity: ingredientDescription!, insertInto: pc)
        
        ingredientItem.nome = ingredientName
        
        do{
            try pc.save()
        } catch{
            print(error)
        }
        
        let alertController = UIAlertController(title: "Sucesso", message: "Ingrediente adicionado com sucesso!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
            return
        })
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)

    }
}
