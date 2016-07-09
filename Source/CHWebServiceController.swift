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
    
    func webServiceController<Objects: Sequence where Objects: ArrayLiteralConvertible>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withSuccess objects: Objects)
    
    func webServiceController<Objects: Sequence where Objects: ArrayLiteralConvertible>(_ controller: CHWebServiceController<Objects>, didRequest section: CHWebServiceSectionInfo<Objects>, withFail result: (statusCode: Int?, error: ErrorProtocol?))
    
}


// MARK: CHWebServiceController

public class CHWebServiceController<Objects: Sequence where Objects: ArrayLiteralConvertible> {
    
    
    // MARK: Property
    
    public private(set) var sections: [CHWebServiceSectionInfo<Objects>] = []
    
    /// The sections that is pending to request.
    internal var pendingQueue: [UUID] = []
    /// The sections that is currently requesting.
    internal var requestingQueue: [Request] = []
    
    public var session = URLSession.shared
    public weak var delegate: CHWebServiceControllerDelegate?
    
    
    // MARK: Init
    
    public init() { }
    
    
    // MARK: Section
    
    public func appendSection(_ section: CHWebServiceSectionInfo<Objects>) {
        
        sections.append(section)
        pendingQueue.append(section.identifier)
        
    }
    
    public func removeSection(with identifier: UUID) {
        
        guard let sectionIndex = sections
            .index(where: { $0.identifier == identifier })
            else { return }
        
        sections.remove(at: sectionIndex)
        
        guard let pendingSectionIndex = pendingQueue
            .index(where: { $0 == identifier })
            else { return }
        
        pendingQueue.remove(at: pendingSectionIndex)
        
        removeSectionFromRequestingQueue(with: identifier)
    
    }
    
    internal func removeSectionFromRequestingQueue(with identifier: UUID) {
        
        guard let index = requestingQueue
            .index(where: { $0.identifier == identifier })
            else { return }
        
        requestingQueue.remove(at: index)
        
    }
    
    
    // MARK: Request
    
    public func performReqeust() {
        
        for index in 0..<pendingQueue.count {
            
            let section = sections[index]
            
            guard let sectionIndex = sections
                .index(where: { $0.identifier == section.identifier })
                else { continue }
            
            request(for: sections[sectionIndex])
            
        }
        
        pendingQueue = []
        
    }
    
    internal func request(for section: CHWebServiceSectionInfo<Objects>, completionHandler: (() -> Void)? = nil) {
        
        let urlSessionTask = section.webService.request(
            with: session,
            errorParser: section.errorParser,
            successHandler: { [weak self] objects in
            
                guard let weakSelf = self else { return }
                
                DispatchQueue.main.async {
                    
                    weakSelf.removeSectionFromRequestingQueue(with: section.identifier)
                    
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
                    
                    weakSelf.removeSectionFromRequestingQueue(with: section.identifier)
                    
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
