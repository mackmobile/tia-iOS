//
//  Horario.swift
//  MackTIA
//
//  Created by joaquim on 01/11/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import Foundation
import CoreData

import Foundation
import CoreData

class Horario: NSManagedObject {
    
    @NSManaged var tia: String
    @NSManaged var codigo: String
    @NSManaged var codigoUnico: String
    @NSManaged var disciplina: String
    @NSManaged var escola: String
    @NSManaged var turma: String
    @NSManaged var local: String
    @NSManaged var predio: String
    @NSManaged var sala: String
    @NSManaged var hora: String
    @NSManaged var dia: String
    @NSManaged var anotacoes: String

    // MARK: Metodos uteis
    
    func salvar() {
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    class func novoHorario()->Horario
    {
        return NSEntityDescription.insertNewObjectForEntityForName("Horario", inManagedObjectContext: CoreDataHelper.sharedInstance.managedObjectContext!) as! Horario
    }
    
    
    /**
     Busca todas os horarios que estão registradas no bando de dados
     
     - returns: Vetor com os horarios existentes ou vetor vazio em caso de erro ou banco vazio
     */
    class func buscarHorarios()->Array<Horario> {
        guard let tia = TIAManager.sharedInstance.usuario?.tia else {
            print("buscarHorarios: error, usuario nao logado")
            return Array<Horario>()
        }
        
        do {
            let fetchRequest = NSFetchRequest(entityName: "Horario")
            fetchRequest.predicate = NSPredicate(format: "tia = %@", tia)
            
            let fetchedResults = try CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults as? [Horario] {
                return results
            } else {
                print("Could not fetch")
            }
        }catch{
            print("Horario.buscarHorario - \(error)")
        }
        
        return Array<Horario>()
    }
    
    
    /**
     Busca um horario com base no dia
     
     - parameter dia: dia da semana, sendo domingo dia 1 e sabado dia 7
     
     - returns: objeto nota com dados atualizados do banco de dados local ou nil caso ocorra algum problema
     */
    class func buscarHorariosDia(dia:Int)->Array<Horario> {
        guard let tia = TIAManager.sharedInstance.usuario?.tia else {
            print("buscarHorariosDia: error, usuario nao logado")
            return Array<Horario>()
        }
        
        do {
            let fetchRequest = NSFetchRequest(entityName: "Horario")
            let predicate = NSPredicate(format: "dia = %@ AND tia = %@", "\(dia)", tia)
            fetchRequest.predicate = predicate
            
            let sortDescriptor = NSSortDescriptor(key: "hora", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
            
            let fetchedResults = try CoreDataHelper.sharedInstance.managedObjectContext?.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            guard let results = fetchedResults as? [Horario] else {
                print("Horario.buscarHorarioPodDia: Could not fetch. Error")
                return []
            }
            
            return results
        }catch{
            print("Horario.buscarHorario - \(error)")
        }
        return []
    }
    
    
    /**
     Busca um horario com base no código da disciplina
     
     - parameter codigo: código da disciplina
     
     - returns: objeto nota com dados atualizados do banco de dados local ou nil caso ocorra algum problema
     */
    class func buscarHorario(codigoUnico:String)->Horario? {
        guard let tia = TIAManager.sharedInstance.usuario?.tia else {
            print("buscarHorario(codigo): error, usuario nao logado")
            return nil
        }
        
        do {
            let fetchRequest = NSFetchRequest(entityName: "Horario")
            let predicate = NSPredicate(format: "codigoUnico = %@ AND tia = %@", codigoUnico, tia)
            fetchRequest.predicate = predicate
            
            let fetchedResults = try CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults as? [Horario] {
                if results.count > 0 {
                    return results[0]
                }
            } else {
                print("Could not fetch. Error")
            }
        }catch{
            print("Horario.buscarHorario - \(error)")
        }
        return nil
    }
    
    /**
     Usado para previnir mudança de grade do aluno
     
     - parameter codigos: códigos das disciplinas válidas, códigos que não existam neste array serão removidos do banco de dados
     */
    private class func removerHorariosDiferentes(codigos:Array<String>) {
        guard let tia = TIAManager.sharedInstance.usuario?.tia else {
            print("removerHorariosDiferentes: error, usuario nao logado")
            return
        }
        
        do{
            if codigos.count == 0 {
                return
            }
            var predicateString = ""
            for i in 0 ..< codigos.count {
                predicateString += "codigoUnico <> '\(codigos[i])'"
                if i < codigos.count - 1 {
                    predicateString += " AND "
                }
            }
            predicateString += "AND tia = '\(tia)'"
            
            let fetchRequest = NSFetchRequest(entityName: "Horario")
            let predicate = NSPredicate(format: predicateString)
            fetchRequest.predicate = predicate
            
            let fetchedResults = try CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            guard let results = fetchedResults as? [Horario] else{
                return
            }
            
            for i in 0 ..< results.count {
                CoreDataHelper.sharedInstance.managedObjectContext!.deleteObject(results[i])
            }
            
            CoreDataHelper.sharedInstance.saveContext()
        }catch{
            print("Horario.removerHorariosDiferentes - \(error)")
        }
    }
    
    /**
     Modelo de resposta JSON valida
     
     {
     "resposta": [
     {
     "codigo": "ENEC00195",
     "nome": "ENGENHARIA DE SOFTWARE I",
     "turma": "03G",
     "escola": "FCI",
     "local": "3100000",
     "predio": "31",
     "sala": "000",
     "hora": "07:30",
     "dia": "2",
     "update": "20151030"
     },
     
     - parameter notaData: NSData
     
     - returns: Vetor com os horarios ou nil em caso de erro
     */
    class func parseJSON(notaData:NSData) -> Array<Horario>? {
        guard let tia = TIAManager.sharedInstance.usuario?.tia else {
            print("parseJSON Horario: error, usuario nao logado")
            return nil
        }
        
        var horarios:Array<Horario>? = Array<Horario>()
        
        var resp:NSDictionary?
        do {
            resp = try NSJSONSerialization.JSONObjectWithData(notaData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
        }catch{
            return nil
        }
        
        guard let resposta = resp else {
            return nil
        }
        
        guard let horariosJSON = resposta.objectForKey("resposta") as? Array<NSDictionary> else {
            return nil
        }
        
        var horariosDiferentes:Array<String> = Array<String>()
        
        for horarioDic in horariosJSON {
            
            var horario:Horario?
            
            guard let codigo = horarioDic["codigo"] as? String,
                let disciplina = horarioDic["nome"] as? String,
                let turma = horarioDic["turma"] as? String,
                let escola = horarioDic["escola"] as? String,
                let local = horarioDic["local"] as? String,
                let predio = horarioDic["predio"] as? String,
                let sala = horarioDic["sala"] as? String,
                let hora = horarioDic["hora"] as? String,
                let dia = horarioDic["dia"] as? String else {
                    print("Problema ao ler o JSON dos horarios\n")
                    return nil
            }
            
            //Importante para nao ter problema com disciplinas
            // que aparecem em mais de um dia e horario
            let codigoUnico = "\(codigo)\(dia)\(hora)"
            
            if let horarioExistente = self.buscarHorario(codigoUnico) {
                horario = horarioExistente
            } else {
                horario = Horario.novoHorario()
                horario?.tia = tia
                horario?.codigoUnico = codigoUnico
                horario?.codigo = codigo
                horariosDiferentes.append(codigoUnico)
                horario?.anotacoes = ""
            }
            
            // WARNING: -Mudar no servidor de nome para disciplina
            horario?.disciplina = disciplina
            horario?.turma = turma
            horario?.escola = escola
            horario?.local = local
            horario?.predio = predio
            horario?.sala = sala
            horario?.hora = hora
            horario?.dia = dia
            
            horario?.salvar()
            horarios?.append(horario!)
        }
        self.removerHorariosDiferentes(horariosDiferentes)
        return horarios
    }
    
    func debug(){
        let weekDays:[String] = ["DOMINGO", "SEGUNDA-FEIRA", "TERÇA-FEIRA", "QUARTA-FEIRA", "QUINTA-FEIRA", "SEXTA-FEIRA", "SABADO"]

        if let diaInt = Int(dia) {
            let diaS:String = weekDays[diaInt-1]
            print("HORARIO: \(diaS) às \(self.hora) no prédio \(self.predio) na sala \(self.sala)\n")
        }else{
            print("HORARIO: \(dia) às \(self.hora) no prédio \(self.predio) na sala \(self.sala)\n")
        }
    }
}
