//
//  SwipeTableViewController+LongPress.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/6/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import SwipeCellKit

struct LongPressPersistentValues {
    static var indexPath: IndexPath?
    static var cellSnapShot: UIView?
}

extension SwipeTableViewController: UIGestureRecognizerDelegate {

    // MARK: - Long Press Setup
    
    func setUpTableViewLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Long Press Gesture Delegate Methods
    
    @objc func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: self.tableView)
        let currentIndexPath = tableView.indexPathForRow(at: locationInView)
        
        switch gestureRecognizer.state {
        case .began:
            handleLongPressBegan(currentIndexPath, locationInView)
        case .changed:
            handleLongPressChanged(locationInView, currentIndexPath)
        default:
            handleLongPressEnded(locationInView, currentIndexPath)
        }
    }
    
    // MARK: - Long Press Gesture Other Methods
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    func handleLongPressBegan(_ currentIndexPath: IndexPath?, _ locationInView: CGPoint) {
        if currentIndexPath != nil {
            LongPressPersistentValues.indexPath = currentIndexPath
            guard let cell = self.tableView.cellForRow(at: currentIndexPath!) as? SwipeTableViewCell else { fatalError() }
            LongPressPersistentValues.cellSnapShot = snapshopOfCell(inputView: cell)
            var center = cell.center
            LongPressPersistentValues.cellSnapShot?.center = center
            LongPressPersistentValues.cellSnapShot?.alpha = 0.0
            tableView.addSubview(LongPressPersistentValues.cellSnapShot!)
            
            UIView.animate(withDuration: 0.25, animations: {
                center.y = locationInView.y
                LongPressPersistentValues.cellSnapShot?.center = center
                LongPressPersistentValues.cellSnapShot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                LongPressPersistentValues.cellSnapShot?.alpha = 0.98
                cell.alpha = 0.0
            }, completion: { _ in
                cell.isHidden = true
            })
        }
    }
    
    func handleLongPressChanged(_ locationInView: CGPoint, _ currentIndexPath: IndexPath?) {
        var center = LongPressPersistentValues.cellSnapShot?.center
        center?.y = locationInView.y
        LongPressPersistentValues.cellSnapShot?.center = center!
        if (currentIndexPath != nil) && (currentIndexPath != LongPressPersistentValues.indexPath) {
            move(from: LongPressPersistentValues.indexPath!, to: currentIndexPath!)
            tableView.moveRow(at: LongPressPersistentValues.indexPath!, to: currentIndexPath!)
            LongPressPersistentValues.indexPath = currentIndexPath
        }
    }
    
    func handleLongPressEnded(_ locationInView: CGPoint, _ currentIndexPath: IndexPath?) {
        guard let cell = tableView.cellForRow(at: LongPressPersistentValues.indexPath!) as? SwipeTableViewCell else { fatalError() }
        cell.isHidden = false
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            LongPressPersistentValues.cellSnapShot?.center = cell.center
            LongPressPersistentValues.cellSnapShot?.transform = .identity
            LongPressPersistentValues.cellSnapShot?.alpha = 0.0
            cell.alpha = 1.0
        }, completion: { (finished) -> Void in
            if finished {
                LongPressPersistentValues.indexPath = nil
                LongPressPersistentValues.cellSnapShot?.removeFromSuperview()
                LongPressPersistentValues.cellSnapShot = nil
                self.tableView.reloadData()
            }
        })
    }
    
}
