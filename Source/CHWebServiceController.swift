//
//  CHWebServiceController.swift
//  Chocolate
//
//  Created by 許郁棋 on 2016/7/6.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation


// MARK: Request

internal struct Request: Equatable, Hashable {
    
    
    // MARK: Property
    
    let identifier: UUID
    let urlSessionTask: URLSessionTask
    
    
    // MARK: Hashable
    
    var hashValue: Int {
        
        return identifier.hashValue ^ urlSessionTask.hashValue
        
    }
    
}

internal func ==(lhs: Request, rhs: Request) -> Bool {
    
    return lhs.identifier == rhs.identifier &&
            lhs.urlSessionTask == rhs.urlSessionTask
    
}


// MARK: CHWebServiceControllerDelegate

public protocol CHWebServiceControllerDelegate: class {
    
    func webServiceController<Objects: ArrayLiteralConvertible>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withSuccess objects: Objects)
    
    func webServiceController<Objects: ArrayLiteralConvertible>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withFail result: (statusCode: Int?, error: ErrorProtocol?))
    
}


// MARK: CHWebServiceController

public class CHWebServiceController<Objects: ArrayLiteralConvertible> {
    
    
    // MARK: Property
    
    public private(set) var sections: [CHWebServiceSectionInfo<Objects>] = []
    
    /// The sections that is pending to request.
    internal var pendingQueue: [UUID] = []
    /// The sections that is currently requesting.
    internal var requestingQueue: [Request] = []
    
    public var session = URLSession.shared()
    public weak var delegate: CHWebServiceControllerDelegate?
    
    
    // MARK: Init
    
    public init() { }
    
    
    // MARK: Section
    
    public func index(of section: CHWebServiceSectionInfo<Objects>) -> Int? {
        
        guard let sectionIndex = sections
            .index(where: { $0 == section })
            else { return nil }
        
        return sectionIndex
        
    }
    
    public func append(section: CHWebServiceSectionInfo<Objects>) {
        
        sections.append(section)
        pendingQueue.append(section.identifier)
        
    }
    
    public func remove(section: CHWebServiceSectionInfo<Objects>) {
        
        guard let sectionIndex = sections
            .index(where: { $0.identifier == section.identifier })
            else { return }
        
        sections.remove(at: sectionIndex)
        
        guard let pendingSectionIndex = pendingQueue
            .index(where: { $0 == section.identifier })
            else { return }
        
        pendingQueue.remove(at: pendingSectionIndex)
        
        removeFromRequestingQueue(for: section)
        
    }
    
    internal func removeFromRequestingQueue(for section: CHWebServiceSectionInfo<Objects>) {
        
        guard let index = requestingQueue
            .index(where: { $0.identifier == section.identifier })
            else { return }
        
        requestingQueue.remove(at: index)
        
    }
    
    
    // MARK: Request
    
    public func performReqeust() {
        
        for index in 0..<pendingQueue.count {
            
            let sectionID = pendingQueue.remove(at: index)
            
            guard let sectionIndex = sections
                .index(where: { $0.identifier == sectionID })
                else { continue }
            
            request(for: sections[sectionIndex])
            
        }
        
    }
    
    internal func request(for section: CHWebServiceSectionInfo<Objects>, completionHandler: (() -> Void)? = nil) {
        
        let urlSessionTask = section.webService.request(
            with: session,
            errorParser: section.errorParser,
            successHandler: { [weak self] objects in
            
                guard let weakSelf = self else { return }
                
                DispatchQueue.main.async {
                    
                    weakSelf.removeFromRequestingQueue(for: section)
                    
                    guard let sectionIndex = weakSelf.sections
                        .index(where: { $0.identifier == section.identifier })
                        else { return }

                    weakSelf.sections[sectionIndex].objects = objects

                    weakSelf.delegate?.webServiceController(
                        weakSelf,
                        didRequest: section,
                        withSuccess: objects
                    )
                    
                    completionHandler?()
                    
                }
                
            },
            failHandler: { [weak self] statusCode, error in
                
                guard let weakSelf = self else { return }
                
                DispatchQueue.main.async {
                    
                    weakSelf.removeFromRequestingQueue(for: section)
                    
                    weakSelf.delegate?.webServiceController(
                        weakSelf,
                        didRequest: section,
                        withFail: (statusCode: statusCode, error: error)
                    )
                    
                    completionHandler?()
                    
                }
                
            }
        )
        
        requestingQueue.append(
            Request(
                identifier: section.identifier,
                urlSessionTask: urlSessionTask
            )
        )
        
    }
    
}