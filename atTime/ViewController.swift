//
//  ViewController.swift
//  atTime
//
//  Created by Matheus Vinícius Teotonio do Nascimento Andrade on 02/03/20.
//  Copyright © 2020 Matheus Vinícius Teotonio do Nascimento Andrade. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Banco de atividades
    var lista : AtividadeBanco = AtividadeBanco()
    var answer : AtividadeBanco = AtividadeBanco()
    
    // Lista de atividades selecionadas
    var actsNames: [String] = [String]()
    
    // Atividades do picker
    var pickerData: [String] = [String]()
    
    // Atividade selecionada no picker
    var act:String = String()
    
    // Estrelas de prioridade
    var stars = [0,0,0]
    
    // Celula da Table View
    let cellReuseIdentifier = "cell"
    
    // Tempo total das atividades
    var totalTime = 0
    
    // Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Estrelas de prioridade
        paintStars(low: false, mid: false, high: false)
        
        // Text Fields
        hoursTextField.keyboardType = UIKeyboardType.numberPad
        minutesTextField.keyboardType = UIKeyboardType.numberPad
        
        hoursTextField.delegate = self
        minutesTextField.delegate = self
        
        // Picker View
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        // Toque na tela
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Picker view Data
        pickerData = ["Academia", "Almoço", "Banho", "Dormir", "Futebol", "Jogar LOL", "Ler", "Netflix", "Vôlei", "Yoga"]
        
        act = pickerData[0]
        
        // Segunda tela
        listView.isHidden = true
        
        hoursTextField.addDoneButtonToKeyboard(myAction:  #selector(self.hoursTextField.resignFirstResponder))
        minutesTextField.addDoneButtonToKeyboard(myAction:  #selector(self.minutesTextField.resignFirstResponder))
        
    }
    
    // Tela da lista de atividades finalizada
    @IBOutlet var listView: UIView!
    
    // Editar Lista
    @IBOutlet var editList: UIView!
    
    // Nova Lista
    @IBOutlet var newList: UIButton!
    
    // Table View
    @IBOutlet var tableView: UITableView!
    
    // Label de tempo total
    @IBOutlet var timeList: UILabel!
    
    // Leitura das horas livres do text field
    @IBOutlet var hoursTextField: UITextField!
    
    // Leitura dos minutos livres do text field
    @IBOutlet var minutesTextField: UITextField!
    
    // Picker View
    @IBOutlet weak var pickerView: UIPickerView!
    
    // Leitura do Stepper
    @IBOutlet var timeStepper: UIStepper!
    
    // Prioridade baixa
    @IBOutlet var lowPriority: UIButton!
    
    // Prioridade média
    @IBOutlet var midPriority: UIButton!
    
    // Prioridade alta
    @IBOutlet var highPriority: UIButton!
    
    // Escrita na label de tempo
    @IBOutlet var timeActivity: UILabel!
    
    // Botão de adicionar ou remover atividade
    @IBOutlet var addOrRemoveAct: UIButton!
    
    // Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        act = pickerData[row]
        
        let index = lista.indexOf(name: act)
        
        // Atividade presente na lista
        if index != -1 {
            addOrRemoveAct.setTitle("Remover Atividade", for: .normal)
            
            paintStars(low: (lista.atividades[index].priority >= 1), mid: (lista.atividades[index].priority >= 2), high: (lista.atividades[index].priority >= 3))
            
            timeStepper.value = Double(lista.atividades[index].time)
            defineTime()
            
        }
        else{
            addOrRemoveAct.setTitle("Adicionar Atividade", for: .normal)
            
            paintStars(low: false, mid: false, high: false)
            
            timeStepper.value = 0
            defineTime()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answer.atividades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        
        cell.textLabel?.text = answer.atividades[indexPath.row].name
        return cell
    }
    
    // Text field de minutos alterado
    @IBAction func minutesTextChanged(_ sender: Any) {
        // Seta o valor maximo do stepper
        timeStepper.maximumValue = Double(getFreeTime())
    }
    
    // Text field de horas alterado
    @IBAction func hoursTextChanged(_ sender: Any) {
        // Seta o valor maximo do stepper
        timeStepper.maximumValue = Double(getFreeTime())
    }
    
    // Botão de prioridade (estrelinhas)
    @IBAction func priorityButton(_ sender: UIButton) {
        
        if sender == lowPriority{
            paintStars(low: true, mid: false, high: false)
        }
        else if sender == midPriority{
            paintStars(low: true, mid: true, high: false)
        }
        else{
            paintStars(low: true, mid: true, high: true)
        }
        
    }
    
    // Apertar stepper
    @IBAction func tapStepper() {
        defineTime()
    }
    
    // Tempo do stepper setado na label de tempo
    func defineTime(){
        var hours: Int
        var minutes: Int
        
        hours = Int(timeStepper.value)/60
        minutes = Int(timeStepper.value) % 60
        
        if(hours != 0){
            timeActivity.text = "\(hours) h \(minutes) min"
        }
        else{
            timeActivity.text = "\(minutes) min"
        }
        
    }
    
    // Botão "Adicionar Atividade"
    @IBAction func clickAddOrRemoveAct() {
        //print("Me contrata logo, Apple!")
        addOrRemoveActivity()
    }
    
    // Editar ou refazer lista
    @IBAction func editOrNewList(_ sender: UIButton) {
        
        if sender == newList{
            lista.atividades.removeAll()
            paintStars(low: false, mid: false, high: false)
            timeStepper.value = 0
            hoursTextField.text = ""
            minutesTextField.text = ""
            addOrRemoveAct.setTitle("Adicionar Atividade", for: .normal)
            totalTime = 0
        }
        
        defineTime()
        listView.isHidden = true
        
        //        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        //        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView.frame = view.bounds
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //
        //        view.willRemoveSubview(blurEffectView)
    }
    
    // Clicando em "Adicionar Atividade"
    func addOrRemoveActivity(){
        // Ler o tempo da atividade em minutos
        let time = Int(timeStepper.value)
        
        // Ler a prioridade da atividade
        var priority = 0
        
        for prio in stars {
            priority += prio
        }
        
        // Atividade não está na lista
        if lista.indexOf(name: act) == -1 {
            // Remove atividade da lista
            
            if(Int(timeStepper.value) ==  0){
                alerta(msg: "Adicione um tempo válido a sua atividade!")
            }
            else if(priority == 0){
                alerta(msg: "Define a prioridade da sua atividade antes de adicioná-la!")
            }
            else{
                addOrRemoveAct.setTitle("Remover Atividade", for: .normal)
                lista.addAtividade(name: act, time: time, priority: priority)
            }
            
        }
            // Atividade está na lista
        else{
            // Adiciona atividade do picker à lista
            addOrRemoveAct.setTitle("Adicionar Atividade", for: .normal)
            lista.removerAtividade(name: act)
            
        }
        
    }
    
    // Botão para finalizar lista
    @IBAction func finishList() {
        
        if(getFreeTime() == 0){
            alerta(msg: "Defina um tempo livre válido!")
        }
        else if(lista.atividades.count > 0){
            knapsackSolution()
            showList()
            tableView.reloadData()
        }
        else{
            alerta(msg: "Você ainda não adicionou nenhuma atividade!")
        }
        
        
    }
    
    // Função de alerta
    func alerta(msg: String){
        let alerta = UIAlertController(title: "Alerta", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let botaoOk = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alerta.addAction(botaoOk)
        self.present(alerta, animated: true, completion: nil)
    }
    
    // Text field fecha ao apertar "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    // Pinta as estrelas de prioridade
    func paintStars(low:Bool, mid:Bool, high: Bool){
        if(low){
            lowPriority.setBackgroundImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
            stars[0] = 1
        }
        else{
            lowPriority.setBackgroundImage(UIImage(systemName: "star"), for: UIControl.State.normal)
            stars[0] = 0
        }
        
        if(mid){
            midPriority.setBackgroundImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
            stars[1] = 1
        }
        else{
            midPriority.setBackgroundImage(UIImage(systemName: "star"), for: UIControl.State.normal)
            stars[1] = 0
        }
        
        if(high){
            highPriority.setBackgroundImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
            stars[2] = 1
        }
        else{
            highPriority.setBackgroundImage(UIImage(systemName: "star"), for: UIControl.State.normal)
            stars[2] = 0
        }
    }
    
    // Pega o tempo livre do usuário
    func getFreeTime() -> Int {
        // Ler o text field de Horas
        let hours = hoursTextField.text!
        var hoursInt : Int
        
        if(hours != ""){
            hoursInt = Int(hours)!
        }
        else{
            hoursInt = 0
        }
        
        // Ler o text field de Minutos
        let minutes = minutesTextField.text!
        var minutesInt : Int
        
        if(minutes != ""){
            minutesInt = Int(minutes)!
        }
        else{
            minutesInt = 0
        }
        
        // Converter string em inteiro
        let time = 60 * hoursInt + minutesInt
        
        // Tempo livre
        return time
        
    }
    
    // Clicando em "Finalizar Lista"
    func knapsackSolution(){
        // Knapsack - monta a lista
        let knapsack = Knapsack(capacity: getFreeTime(), activities: lista)
        
        // Tempo das atividades finais
        
        let res : (AtividadeBanco, Int)
        
        
        res = knapsack.knapsack()
        answer = res.0
        totalTime = res.1
        
        // Mostra o tempo das atividades
        print("Minha lista:")
        
        for (i, atv) in answer.atividades.enumerated(){
            print("\(i+1). \(atv.name) - \(atv.time)")
        }
    }
    
    func showList(){
        // Borra a tela inicial
        //        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        //        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView.frame = view.bounds
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //
        //        view.addSubview(blurEffectView)
        //
        listView.isHidden = false
        
        if(totalTime >= 60){
            timeList.text = "Tempo Total: \(totalTime/60) h \(totalTime % 60) min"
        }
        else{
            timeList.text = "Tempo Total: \(totalTime % 60) min"
        }
        
    }
    
}

extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Retornar", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}


