//
//  ViewController.swift
//  MyTodoListProject
//
//  Created by Ruslan Ismailov on 06/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    //доступ к модели
    let model = Model()
    
    //доступ к возможностям алерта
    var alert = UIAlertController()
    
    //доступ к возможностям табличным формам
    var myTableView = UITableView()
    
    //оутлеты на кнопку и верхнее вью с кнопками
    @IBOutlet weak var sortIcon: UIButton!
    @IBOutlet weak var topView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //создаю табличную форму кодом
        myTableView = UITableView(frame: CGRect(x: 0, y: 120, width: Int(view.frame.width), height: Int(self.view.frame.height)), style: .plain)
        
        //задаю фон всему экрану для дизайна
        view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 0.9, alpha: 1)
        
        //фон для таблицы
        myTableView.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.1)
        
        //определение делегатов и датасорса для таблицы
        myTableView.delegate = self
        myTableView.dataSource = self
        
        //добавление таблицы в главное вью
        view.addSubview(myTableView)
        //добавление шапки во вью
        view.didAddSubview(topView)
        
        //включаю режим сортировки
        model.sortByTitle()
        
        //обновление таблицы
        myTableView.reloadData()
    }
    
    //дествие от нажатия на кнопку сортировки
    @IBAction func sortButtonAction(_ sender: Any) {
        //подвязывание иконок стрелок
        let arrowUp = UIImage(systemName: "arrow.up.circle")
        let arrowDown = UIImage(systemName: "arrow.down.circle")
        
        //переключатель булевой переменной
        model.sortedItem = !model.sortedItem
        //указание какой иконке быть при нажатии
        let arrow = model.sortedItem ? arrowUp : arrowDown
        //внесения стрелки в иконку кнопки
        sortIcon.setImage(arrow, for: .normal)
        //сортировка
        model.sortByTitle()
        //обновление
        myTableView.reloadData()
    }
    
    //действие на кнопку добавить задачу в список
    @IBAction func addButtonAction(_ sender: Any) {
        //присваивание алерту название, которое сверху. Использовал оригинал с примера, изучил по ходу кода
        alert = UIAlertController(title: "Create new task", message: nil, preferredStyle: .alert)
        //добавление поля для ввода текста и создание замыкания в нем
        alert.addTextField { (textField: UITextField) in
            //текст который будет как подсказка в строчке
            textField.placeholder = "Put your task here"
            //указание на проверку повяления текста в строке и активацию кнопки
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        // создание константы на кнопку создать
        let createAlertAction = UIAlertAction(title: "Create", style: .default) { (createAlert) in
            //создание константы в которую передаем текст что написали в поле
            guard let unwrTextFieldValue = self.alert.textFields?[0].text else {
                return
            }
            //передача текста в модель с созданием новой задачи
            self.model.addNewTask(name: unwrTextFieldValue, state: true)
            //обновление таблицы
            self.myTableView.reloadData()
        }
        //создание кнопки отмены
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //добавление кнопок в алерт
        alert.addAction(cancelAlertAction)
        alert.addAction(createAlertAction)
        //метод передачи данных
        present(alert, animated: true, completion: nil)
        //деактивируем кнопку до нужного момента
        createAlertAction.isEnabled = false
        
    }
    
    //селектор, который проверяет что текст был введен в строку иначе кнопка создать не активна
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        //константа с переданным текстом, алерт получил сигнал о появлении текста
        guard let senderText = sender.text, alert.actions.indices.contains(1) else {
            return
        }
        
        let action = alert.actions[1]
        print(alert.actions[1])
        
        //передача количества больше нуля
        action.isEnabled = senderText.count > 0
    }
}


//расширение для табличной формы передачи данных и делегатов
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    //количество секций оставляю одну
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.itemArray.count
    }
    
    //определяю кастомную ячейку созданную отдельно через xib файл
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //подключение кастомной ячейки
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        //определение ячейки
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {return UITableViewCell()}
        
        //подключаем делегат из кастомной ячейки
        cell.delegateCell = self
        
        //определяем текущую ячейку из массива предзагрузки
        let currentItem = model.itemArray[indexPath.row]
        
        //передаем текст из массива в ячейку
        cell.labelCell.text = currentItem.label
        //при подтягивании с массива есть выполненные задания, отмечаем это
        if currentItem.doneTask{
            cell.buttonDoneTask.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            cell.buttonDoneTask.tintColor = UIColor(displayP3Red: 0.3, green: 0.7, blue: 0.3, alpha: 1)
        }else{
            cell.buttonDoneTask.setImage(UIImage(systemName: "square"), for: .normal)
            cell.buttonDoneTask.tintColor = .tintColor
        }
        
        //закрасил ячейку под стиль фона
        cell.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.1)
        
        return cell
    }
    
    //метод нажатия на ячейку, как альтернатива нажатия на кнопку выполнения задания
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //определяем индекс нажатой ячейки
        let currentItem = model.itemArray[indexPath.row]
        //переключатель на противоположный
        currentItem.doneTask = !currentItem.doneTask
        //обновление таблицы
        myTableView.reloadData()
    }
    
}

//добавление протокола для выполнениея обязательных функций
extension ViewController: CustomCellDelegate{
    //функция изменения ячейки
    func editCell(cell: CustomTableViewCell) {
        //текущий индекс
        let indexPath = myTableView.indexPath(for: cell)
        //наименование алерта, а так же указал комментарии того что изменил из кода выше
        alert = UIAlertController(title: "Change task name", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            //тут уже внес изменения чтоб появлялся текст написанный ранее в ячейке
            textField.text = self.model.itemArray[indexPath!.row].label
            //селектор отрабатывает из алерта с добавлением новой задачи
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        //сменил название кнопки
        let createAlertAction = UIAlertAction(title: "Change", style: .default) { (createAlert) in
            
            guard let unwrTextFieldValue = self.alert.textFields?[0].text else {
                return
            }
            //отработка метода из модели
            self.model.changeItem(name: unwrTextFieldValue, index: indexPath!.row)
            //обновление таблицы
            self.myTableView.reloadData()
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(cancelAlertAction)
        alert.addAction(createAlertAction)
        present(alert, animated: true, completion: nil)
        createAlertAction.isEnabled = false
    }
    
    //удаление ячейки
    func deleteCell(cell: CustomTableViewCell) {
        //получение индекса
        let indexPath = myTableView.indexPath(for: cell)
        //проверка наличия этого индекса
        guard let unwrIndexPath = indexPath else {
            return
        }
        //отработка метода из модели
        model.deleteTask(index: unwrIndexPath.row)
        //обновление таблицы
        myTableView.reloadData()
    }
    
    //кнопка выполнения задания
    func didDoneCell(cell: CustomTableViewCell) {
        //получение индекса
        let indexPath = myTableView.indexPath(for: cell)
        //проверка наличия этого индекса
        guard let unwrIndexPath = indexPath else {
            return
        }
        //отработка метода из модели
        model.didDoneTask(index: unwrIndexPath.row)
        //обновление таблицы
        myTableView.reloadData()
    }
}
