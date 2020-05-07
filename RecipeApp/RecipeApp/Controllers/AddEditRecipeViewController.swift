//
//  AddEditRecipeViewController.swift
//  RecipeApp
//
//  Created by Akhlaq Ahmad on 06/05/2020.
//  Copyright © 2020 Akhlaq Ahmad. All rights reserved.
//

import UIKit

protocol AddEditRecipeViewControllerDelegate: class {
    func reloadRecipes()
}

class AddEditRecipeViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addOrChangePhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var stepsTextView: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    weak var delegate: AddEditRecipeViewControllerDelegate?
    
    private var recipeTypes: [RecipeType] {
        return recipeClient.recipeTypes
    }
    var recipeClient: RecipeClient!
    var selectedRecipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    @IBAction func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped() {
        if selectedRecipe == nil {
            let recipe = Recipe()
            recipe.name = nameTextField.text ?? ""
            recipe.type = typeTextField.text ?? ""
            recipe.ingredients = ingredientsTextView.text ?? ""
            recipe.steps = stepsTextView.text ?? ""
            recipeClient.addRecipe(recipe)
            dismiss(animated: true, completion: nil)
        } else {
            try? recipeClient.realmManager.update {
                self.selectedRecipe?.name        = self.nameTextField.text ?? ""
                self.selectedRecipe?.type        = self.typeTextField.text ?? ""
                self.selectedRecipe?.ingredients = self.ingredientsTextView.text ?? ""
                self.selectedRecipe?.steps       = self.stepsTextView.text ?? ""
            }
//            recipeClient.updateRecipe(selectedRecipe!)
            self.navigationController?.popViewController(animated: true)
        }
        delegate?.reloadRecipes()
    }
    
    @IBAction func deleteButtonTapped() {
        recipeClient.realmManager.delete(object: selectedRecipe!)
        self.navigationController?.popViewController(animated: true)
        delegate?.reloadRecipes()
    }

}

extension AddEditRecipeViewController {
    private func setupUI() {
        if let recipe = selectedRecipe {
            // edit mode
            navigationBar.isHidden = true
            title = "Update Recipe"
            topLayoutConstraint.constant = 20
            nameTextField.text = recipe.name
            typeTextField.text = recipe.type
            ingredientsTextView.text = recipe.ingredients
            stepsTextView.text = recipe.steps
            imageView.sd_setImage(with: URL(string: recipe.imageUrl), placeholderImage: #imageLiteral(resourceName: "recipe_placeholder"))
            
            if !recipe.imageUrl.isEmpty {
                addOrChangePhotoButton.setTitle("Change Photo", for: .normal)
            }
        } else {
            deleteButton.isHidden = true
        }
        typeTextField.inputView = pickerView
    }
}


extension AddEditRecipeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeTypes.count
    }
}

extension AddEditRecipeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeTypes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = recipeTypes[row].name
    }
}


extension AddEditRecipeViewController: UITextFieldDelegate {
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
