//
//  CustomTableViewCell.swift
//  MyTodoListProject
//
//  Created by Ruslan Ismailov on 07/08/22.
//

import UIKit

//создание протокола для делегирования от нажатия на кнопки кастомной ячейки
protocol CustomCellDelegate {
    func editCell(cell: CustomTableViewCell)
    func deleteCell(cell: CustomTableViewCell)
    func didDoneCell(cell: CustomTableViewCell)
}

//класс кастомной ячейка
class CustomTableViewCell: UITableViewCell {
    
    //оутлеты всех кнопок и лейбла с ячейки
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var buttonDoneTask: UIButton!
    @IBOutlet weak var removeTaskButton: UIButton!
    
    //делегат от протокола на выполнения обязательных функций
    var delegateCell: CustomCellDelegate?
    
    //автоматически созданная функция
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //автоматически созданная функция
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //экшн от нажатия на кнопку выполнения задания
    @IBAction func doneButton(_ sender: Any) {
        //если вызывается делегат то он выполняет функцию из протокола
        delegateCell?.didDoneCell(cell: self)
    }
    
    //действие на нажатие кнопки удалить
    @IBAction func removeButton(_ sender: Any) {
        delegateCell?.deleteCell(cell: self)
    }
    
    //действие на нажатие кнопки редактировать
    @IBAction func editButton(_ sender: Any) {
        delegateCell?.editCell(cell: self)
    }
    
}

