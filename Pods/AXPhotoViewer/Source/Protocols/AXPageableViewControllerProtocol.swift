//
//  AXPageableViewControllerProtocol.swift
//  AXPhotoViewer
//
//  Created by Alex Hill on 6/4/17.
//  Copyright © 2017 Alex Hill. All rights reserved.
//

@objc protocol AXPageableViewControllerProtocol: AnyObject, NSObjectProtocol {
    
    var pageIndex: Int { get set }
    
    @objc optional func prepareForReuse()
    @objc optional func prepareForRecycle()
    
}
