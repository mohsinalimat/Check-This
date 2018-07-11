//
//  SwipeTableViewController+LongPress.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/6/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import SwipeCellKit

// MARK: - Long Press Gesture

extension SwipeTableViewController: UIGestureRecognizerDelegate {

    func setUpTableViewLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
//    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
//        if gestureRecognizer.state == .ended {
//            tableView.isEditing = false
//            let touchPoint = gestureRecognizer.location(in: self.tableView)
//            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
//                print("indexPath.row: ", indexPath.row)
//            }
//        }
//        if gestureRecognizer.state == .began {
//            tableView.isEditing = true
//            print("\ngesture BEGAN")
//        }
//    }
    
    @objc func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        
        let state = gestureRecognizer.state
        let locationInView = gestureRecognizer.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: locationInView)
        
        switch state {
        case .began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                guard let cell = self.tableView.cellForRow(at: indexPath!) as? SwipeTableViewCell else { fatalError() }
                My.cellSnapShot = snapshopOfCell(inputView: cell)
                var center = cell.center
                My.cellSnapShot?.center = center
                My.cellSnapShot?.alpha = 0.0
                self.tableView.addSubview(My.cellSnapShot!)
                
                UIView.animate(withDuration: 0.25, animations: {
                    center.y = locationInView.y
                    My.cellSnapShot?.center = center
                    My.cellSnapShot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapShot?.alpha = 0.98
                    cell.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        cell.isHidden = true
                    }
                })
            }
            
        case .changed:
            var center = My.cellSnapShot?.center
            center?.y = locationInView.y
            My.cellSnapShot?.center = center!
            if (indexPath != nil) && (indexPath != Path.initialIndexPath) {
                
                self.move(from: Path.initialIndexPath!, to: indexPath!)
                //swap(&self.wayPoints[(indexPath?.row)!], &self.wayPoints[(Path.initialIndexPath?.row)!])
                self.tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                Path.initialIndexPath = indexPath
            }
            
        default:
            guard let cell = self.tableView.cellForRow(at: Path.initialIndexPath!) as? SwipeTableViewCell else { fatalError() }
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                My.cellSnapShot?.center = cell.center
                My.cellSnapShot?.transform = .identity
                My.cellSnapShot?.alpha = 0.0
                cell.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    Path.initialIndexPath = nil
                    My.cellSnapShot?.removeFromSuperview()
                    My.cellSnapShot = nil
                }
            })
        }
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    struct My {
        static var cellSnapShot: UIView?
    }
    
    struct Path {
        static var initialIndexPath: IndexPath?
    }
}
