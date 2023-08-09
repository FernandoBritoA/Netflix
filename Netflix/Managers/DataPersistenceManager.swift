//
//  DataPersistenceManager.swift
//  Netflix
//
//  Created by Fernando Brito on 09/08/23.
//

import Foundation
import UIKit
import CoreData

// This class is responsible dor downloading data and talking to CoreData API

enum DatabaseError: Error {
    case failedToSaveData
    case failedToFetchData
}

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    func downloadTitle(with model: Title, completion: @escaping (Result<Void, Error>) -> Void){
        // Reference to the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // What is going to be saved on the data base with the supervision of the context manager
        let item = TitleItem(context: context)
        
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do{
            try context.save()
            
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
        
    }
    
    func fetchingTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void){
        // Reference to the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            
            completion(.success(titles))
        } catch {
            print(error.localizedDescription)
            
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
}
