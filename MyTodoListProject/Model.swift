//
//  Model.swift
//  MyTodoListProject
//
//  Created by Ruslan Ismailov on 06/08/22.
//

import Foundation
import UIKit

//создание класса для элементов массива с данными
class CellItem {
    var label: String
    var doneTask: Bool

    init(label: String, doneTask: Bool) {
        self.label = label
        self.doneTask = doneTask
    }
}



class Model {
//создание массива, который предзагрузится
    var itemArray: [CellItem] = [
                                CellItem(label: "Do something", doneTask: false),
                                CellItem(label: "Task1", doneTask: true),
                                CellItem(label: "Create app", doneTask: false),
                                CellItem(label: "Change mind about skils", doneTask: false),
                                ]
    
    // переменная для сортировки
    var sortedItem: Bool = true
    //метод для добавления элемента в массив
    func addNewTask(name: String, state: Bool){
        itemArray.append(CellItem(label: name, doneTask: state == false))
    }
    //метод удаления элемента из массива
    func deleteTask(index: Int){
        itemArray.remove(at: index)
    }
    //изменение наименования созданной ячейки списка
    func changeItem(name: String, index: Int){
        itemArray[index].label = name
    }
    //галочка выполненного задания
    func didDoneTask(index: Int){
        itemArray[index].doneTask = !itemArray[index].doneTask
    }
    //сортировка элементов
    func sortByTitle() {
        itemArray.sort{
            sortedItem ? $0.label < $1.label : $0.label > $1.label
        }
        
    }
}

