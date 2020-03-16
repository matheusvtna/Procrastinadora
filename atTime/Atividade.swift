//
//  Atividade.swift
//  atTime
//
//  Created by Matheus Vinícius Teotonio do Nascimento Andrade on 09/03/20.
//  Copyright © 2020 Matheus Vinícius Teotonio do Nascimento Andrade. All rights reserved.
//

import Foundation

class Atividade {
    
    var name: String
    var time: Int
    var priority: Int
    
    init(name: String, time: Int, priority: Int){
        self.name = name
        self.time = time
        self.priority = priority
    }
}

class AtividadeBanco {
    var atividades: [Atividade]
    
    init(){
        atividades = []
    }
    
    // Adiciona atividade ao banco
    func addAtividade(name: String, time: Int, priority:Int){
        atividades.append(Atividade(name: name, time: time, priority: priority))
    }
    
    func addAtividade(Atividade: Atividade){
        atividades.append(Atividade)
    }
    
    // Retorna o index do elemento com nome "name"
    func indexOf(name: String) -> Int{
        
        for (index, atv) in atividades.enumerated() {
            if(atv.name == name){
                return index
            }
        }
        
        return -1
    }
    
    // Remove atividade de nome "name"
    func removerAtividade(name: String){
        let index = indexOf(name: name)
        
        if(index != -1){
            atividades.remove(at: index)
        }
        
    }
    
    // Indica a forma de ordenação
    //    func order(obj1: Atividade, obj2: Atividade) -> Bool{
    //
    //        if(obj1.time != obj2.time){
    //            return obj1.time < obj2.time
    //        }
    //        if(obj1.priority != obj2.priority){
    //            return obj1.priority > obj2.priority
    //        }
    //
    //        return obj1.name < obj2.name
    //
    //    }
    //
}
