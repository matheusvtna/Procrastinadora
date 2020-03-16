//
//  Knapsack.swift
//  atTime
//
//  Created by Matheus Vinícius Teotonio do Nascimento Andrade on 10/03/20.
//  Copyright © 2020 Matheus Vinícius Teotonio do Nascimento Andrade. All rights reserved.
//

import Foundation

public final class Knapsack{
    
    var capacityOfBag: Int
    var knapsackItems: AtividadeBanco
    
    init(capacity: Int, activities: AtividadeBanco){
        self.capacityOfBag = capacity
        self.knapsackItems = activities
    }
    
    func knapsack() -> (AtividadeBanco, Int) {
        var tableOfValues = [[Int]]()
     
        tableOfValues = Array(repeating: Array(repeating: 0, count: capacityOfBag+1),
                              count: knapsackItems.atividades.count+1)
        
        for itemIndex in 1...knapsackItems.atividades.count{
            for totalTime in 1...capacityOfBag{
                
                if(totalTime < knapsackItems.atividades[itemIndex-1].time){
                    tableOfValues[itemIndex][totalTime] = tableOfValues[itemIndex-1][totalTime]
                }
                else{
                    let remainingCapacity = totalTime - knapsackItems.atividades[itemIndex-1].time
                    tableOfValues[itemIndex][totalTime] = max(knapsackItems.atividades[itemIndex-1].priority + tableOfValues[itemIndex-1][remainingCapacity], tableOfValues[itemIndex-1][totalTime])
                }
            
            }
        }

        var res = tableOfValues[knapsackItems.atividades.count][capacityOfBag]
        var w = capacityOfBag
        var i = knapsackItems.atividades.count
        var acts : AtividadeBanco = AtividadeBanco()
        
        while(i > 0 && res > 0){

            if(res != tableOfValues[i-1][w]){
                //print(knapsackItems.atividades[i-1].name)
                
                acts.addAtividade(Atividade: knapsackItems.atividades[i-1])
                res = res - knapsackItems.atividades[i-1].priority
                w = w - knapsackItems.atividades[i-1].time
            }
            
            i = i - 1
            
        }
        
        var time : Int = 0
        
        for atv in acts.atividades{
            time += atv.time
        }
        
        return (acts, time)
        
        // return tableOfValues[knapsackItems.atividades.count][capacityOfBag]
        
    }
    
}
