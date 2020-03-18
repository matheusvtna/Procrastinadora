//
//  ViewController.swift
//  atTime
//
//  Created by Matheus Vinícius Teotonio do Nascimento Andrade on 02/03/20.
//  Copyright © 2020 Matheus Vinícius Teotonio do Nascimento Andrade. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout,
    UITableViewDelegate, UITableViewDataSource
{
    var lista : AtividadeBanco = AtividadeBanco()
    var answer : AtividadeBanco = AtividadeBanco()
    
    var actsNames: [String] = [String]()
        
    var act:String = String()
    
    var stars = [0,0,0]
    
    let cellReuseIdentifier = "cell"
    
    var totalTime = 0
    
    private var activities = Activity.createActivities()
        
    private struct Storyboard{
        static let CellIdentifier = "Activities Cell"
    }
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var hoursTextField: UITextField!
    @IBOutlet var minutesTextField: UITextField!
    @IBOutlet var timeStepper: UIStepper!
    @IBOutlet var lowPriority: UIButton!
    @IBOutlet var midPriority: UIButton!
    @IBOutlet var highPriority: UIButton!
    @IBOutlet var timeActivity: UILabel!
    @IBOutlet var addOrRemoveAct: UIButton!
    @IBOutlet var listView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var timeList: UILabel!
    @IBOutlet var editList: UIButton!
    @IBOutlet var newList: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        paintStars(low: false, mid: false, high: false)
        
        // Text Fields
        hoursTextField.keyboardType = UIKeyboardType.numberPad
        minutesTextField.keyboardType = UIKeyboardType.numberPad
        
        hoursTextField.delegate = self
        minutesTextField.delegate = self
        
        // Collection View
        collectionView.delegate = self
        collectionView.dataSource = self

        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        
        hoursTextField.addDoneButtonToKeyboard(myAction:  #selector(self.hoursTextField.resignFirstResponder))
        minutesTextField.addDoneButtonToKeyboard(myAction:  #selector(self.minutesTextField.resignFirstResponder))
        
        act = activities[0].name
        
        collectionView.allowsMultipleSelection = false
        collectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: .centeredHorizontally)
        
        listView.isHidden = true
        
    }
    
    // Actions and functios
    @IBAction func minutesTextChanged(_ sender: Any) {
        timeStepper.maximumValue = Double(getFreeTime())
    }
    
    @IBAction func hoursTextChanged(_ sender: Any) {
        timeStepper.maximumValue = Double(getFreeTime())
    }
    
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
    
    @IBAction func tapStepper() {
        defineTime()
    }
    
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
    
    @IBAction func clickAddOrRemoveAct() {
        //print("Me contrata logo, Apple!")
        addOrRemoveActivity()
    }
    
    func addOrRemoveActivity(){
        let time = Int(timeStepper.value)
        
        var priority = 0
        
        for prio in stars {
            priority += prio
        }
        
        if lista.indexOf(name: act) == -1 {
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
        else{
            addOrRemoveAct.setTitle("Adicionar Atividade", for: .normal)
            lista.removerAtividade(name: act)
        }
    }
    
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
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Reusable Cell", for: indexPath) as! ActivityCollectionViewCell
        
        cell.activity = self.activities[indexPath.item]
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    
        let cell = collectionView.cellForItem(at: indexPath) as! ActivityCollectionViewCell
        
        cell.backgroundColor = addOrRemoveAct.tintColor
        
        act = cell.activityLabel.text!
        print(act)
        
        let index = lista.indexOf(name: act)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.backgroundColor = UIColor.clear
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout

        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee

        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing

        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)

        targetContentOffset.pointee = offset

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answer.atividades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TableView Cell") ?? UITableViewCell()
        
        let timeAct = answer.atividades[indexPath.row].time
        var time = ""
        
        if(timeAct >= 60){
            time = "\(timeAct/60) h "
        }
        
        time += "\(timeAct % 60) min"
        
        cell.textLabel?.text = answer.atividades[indexPath.row].name
        cell.detailTextLabel?.text = time
        return cell
    }
    
    func alerta(msg: String){
        let alerta = UIAlertController(title: "Alerta", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let botaoOk = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alerta.addAction(botaoOk)
        self.present(alerta, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
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
    
    func getFreeTime() -> Int {
        let hours = hoursTextField.text!
        var hoursInt : Int
        
        if(hours != ""){
            hoursInt = Int(hours)!
        }
        else{
            hoursInt = 0
        }
        
        let minutes = minutesTextField.text!
        var minutesInt : Int
        
        if(minutes != ""){
            minutesInt = Int(minutes)!
        }
        else{
            minutesInt = 0
        }
        
        let time = 60 * hoursInt + minutesInt
        
        return time
        
    }
    
    func knapsackSolution(){
        let knapsack = Knapsack(capacity: getFreeTime(), activities: lista)
                
        let res : (AtividadeBanco, Int)
        
        res = knapsack.knapsack()
        answer = res.0
        totalTime = res.1
        
    }
    
    func showList(){
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


