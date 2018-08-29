//
//  CoreDataHelper.swift
//  Zhongwei
//
//  Created by eesee on 2018/4/3.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    static let instance = CoreDataHelper()
    
    var app:AppDelegate!
    
    private init() {
        app = UIApplication.shared.delegate as! AppDelegate
    }
    
    public func saveShopItem(shopItem:ShopItem) {
        let context = app.persistentContainer.viewContext as! NSManagedObjectContext
        let fetchRequest = NSFetchRequest<ShopHistory>(entityName:"ShopHistory")
        fetchRequest.fetchLimit = 20
        let predicate = NSPredicate(format: "shopId='\(shopItem.club_id!)'", "")
        fetchRequest.predicate = predicate
        do{
            let fetchedObjects = try context.fetch(fetchRequest)
            for result in fetchedObjects {
                print(result.shopName)
            }
            if (fetchedObjects.count > 0) {
                fetchedObjects[0].time = Date()
                try context.save()
            } else {
                if let entity = NSEntityDescription.insertNewObject(forEntityName: "ShopHistory", into: context) as? ShopHistory {
                    entity.shopId = shopItem.club_id
                    entity.ownerName = shopItem.name
                    entity.shopName = shopItem.club_name
                    entity.phone = shopItem.phone
                    entity.address = shopItem.address
                    entity.time = Date()
                    do {
                        try context.save()
                    } catch (let error) {
                        Log(error)
                    }
                }
            }
        } catch(let error) {
            Log(error)
        }
    }
    
    public func getShopHistoryList() -> [ShopItem]{
        let context = app.persistentContainer.viewContext as! NSManagedObjectContext
        var shopList = [ShopItem]()
        let fetchRequest = NSFetchRequest<ShopHistory>(entityName:"ShopHistory")
        fetchRequest.fetchLimit = 20
        //let predicate = NSPredicate(format: "*", "")
        //fetchRequest.predicate = predicate
        let sort:NSSortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do{
            let fetchedObjects = try context.fetch(fetchRequest)
            if (fetchedObjects.count <= 0) {
                return shopList
            }
            for result in fetchedObjects {
                if (result != nil) {
                    print("\(result.shopName!) \(result.time!)")
                    var shopItem = ShopItem()
                    shopItem.club_name = result.shopName
                    shopItem.club_id = result.shopId
                    shopItem.phone = result.phone
                    shopItem.name = result.ownerName
                    shopItem.address = result.address
                    shopList.append(shopItem)
                }
            }
        } catch(let error) {
            Log(error)
        }
        return shopList
    }
    
    public func deleteHistory() {
        let context = app.persistentContainer.viewContext as! NSManagedObjectContext
        let fetchRequest = NSFetchRequest<ShopHistory>(entityName:"ShopHistory")
        do{
            let fetchedObjects = try context.fetch(fetchRequest)
            for result in fetchedObjects {
                context.delete(result)
            }
            try context.save()
        } catch(let error) {
            Log(error)
        }
    }
}
