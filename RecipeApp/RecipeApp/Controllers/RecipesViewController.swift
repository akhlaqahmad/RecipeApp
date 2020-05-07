//
//  RecipesViewController.swift
//  RecipeApp
//
//  Created by Akhlaq Ahmad on 05/05/2020.
//  Copyright © 2020 Akhlaq Ahmad. All rights reserved.
//

import UIKit
import SDWebImage

class RecipesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private let recipeClient = RecipeClient()
    private var recipeTypes: [RecipeType] {
        return recipeClient.recipeTypes
    }
    private var recipes: [Recipe]!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addEditRecipeVC = segue.destination as! AddEditRecipeViewController
        addEditRecipeVC.delegate = self
        addEditRecipeVC.recipeClient = recipeClient
        if segue.identifier == "UpdateRecipe", let indexPath = tableView.indexPathForSelectedRow {
            addEditRecipeVC.selectedRecipe = recipes[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.inputView = pickerView
        recipeClient.loadRecipeTypes()
        recipeClient.loadRecipes()
        recipes = recipeClient.fetchRecipes()
    }
    
    @IBAction func filterButtonTapped() {
        let type = textField.text ?? ""
        recipes = recipeClient.fetchRecipes(of: type)
        tableView.reloadData()
        textField.resignFirstResponder()
    }
    
}

extension RecipesViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeTypes.count
    }
}

extension RecipesViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeTypes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = recipeTypes[row].name
    }
}

extension RecipesViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        filterButtonTapped()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? false {
            textField.text = recipeTypes[0].name
            pickerView.selectRow(0, inComponent: 0, animated: true)
        } else {
            let name = textField.text ?? ""
            let index = recipeTypes.firstIndex(where: { $0.name == name }) ?? 0
            pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
}

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        let recipe = recipes[indexPath.row]
        cell.nameLabel.text = recipe.name
        cell.recipeImageView.sd_setImage(with: URL(string: recipe.imageUrl), placeholderImage: #imageLiteral(resourceName: "recipe_placeholder"))
        return cell
    }
}

extension RecipesViewController: AddEditRecipeViewControllerDelegate {
    func reloadRecipes() {
        recipes = recipeClient.fetchRecipes()
        tableView.reloadData()
    }
}
