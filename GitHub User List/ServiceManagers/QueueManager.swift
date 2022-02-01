//
//  QueueManager.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 27/01/2022.
//

import Foundation

import Foundation

class QueueManager {
    
    private(set) lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        return queue;
    }()

    static let shared = QueueManager()

    func enqueue(_ operation: Operation) {
        queue.addOperation(operation)
    }

    func addOperations(_ operations: [Operation]) {
        queue.addOperations(operations, waitUntilFinished: true)
    }
    
    ///Returns true if the operation with same name is alrady added in queue.
    func containsOperation(_ operationName: String) -> Bool {
        return queue.operations.contains(where: {$0.name == operationName})
    }
}
