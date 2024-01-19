//
//  RealmManager.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 18/01/24.
//

import Foundation
import RxSwift
import Realm
import RealmSwift
import RxRealm
import RxCocoa

protocol AbstractRepository {
    associatedtype T
    func queryAll() -> Observable<[T]>
    func query(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[T]>
    func save(entity: T) -> Observable<Void>
    func delete(entity: T) -> Observable<Void>
}

final class RealmManager<T: Object>: AbstractRepository where T: Object {
    
    private let configuration = Realm.Configuration()

    private var realm: Realm {
        do {
            let realm = try Realm(configuration: Realm.Configuration())
            return realm
        } catch {
            print(error)
        }
        return self.realm
    }
    
    func queryAll() -> Observable<[T]> {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.self)
            return Observable.array(from: objects)
        }
    }
    
    func query(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[T]> {
        return Observable.array(from: self.realm.objects(T.self).filter(predicate))
    }
    
    func getById(obj: T.Type, id: Any) -> Observable<T?> {
        return Observable.from(optional: self.realm.object(ofType: T.self, forPrimaryKey: id))
    }
    
    func save(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.save(item: entity, update: true)
        }
    }
    
    func delete(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.delete(item: entity)
        }
    }
}

extension Reactive where Base == Realm {
    func save<T: Object>(item: T, update: Bool = true) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(item, update: update ? .all : .error)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    func delete<T: Object>(item: T) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.delete(item)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
