//
//  CustomTableVC+LongPress.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/6/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit
import SwipeCellKit

private struct LongPressPersistentValues {
    static var indexPath: IndexPath?
    static var cellSnapShot: UIView?
    static var gestureLocationBeforeMovingRow: CGPoint?
}

extension CustomTableVC: UIGestureRecognizerDelegate {

    // MARK: - Long Press Setup
    
    func setUpTableViewLongPressGesture() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        longPressGestureRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    // MARK: - Long Press Gesture Delegate Methods
    
    @objc func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            handleLongPressBeganFor(gestureRecognizer)
        case .changed:
            handleLongPressChangedFor(gestureRecognizer)
        case .ended:
            handleLongPressEnded()
        default:
            break
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
    
    func handleLongPressBeganFor(_ gestureRecognizer: UIGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: self.tableView)
        let currentIndexPath = tableView.indexPathForRow(at: locationInView)

        let hapticGenerator = UINotificationFeedbackGenerator()
        hapticGenerator.notificationOccurred(.success)
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
    
    func handleLongPressChangedFor(_ gestureRecognizer: UIGestureRecognizer) {
//        print("\ngestureRecognizer.location: \(gestureRecognizer.location(in: self.tableView))")
//        let locationInView: CGPoint?
//        if LongPressPersistentValues.gestureLocationBeforeMovingRow != nil && gestureRecognizer.location(in: self.tableView) != LongPressPersistentValues.gestureLocationBeforeMovingRow { // swiftlint:disable:this line_length
////        if LongPressPersistentValues.gestureLocationBeforeMovingRow != nil {
//            print("TOP LINE")
//            print("TOP LINE LongPressPersistentValues.gestureLocationBeforeMovingRow: \(String(describing: LongPressPersistentValues.gestureLocationBeforeMovingRow))") // swiftlint:disable:this line_length
//            locationInView = LongPressPersistentValues.gestureLocationBeforeMovingRow
//            print("TOP LINE locationInView: \(String(describing: locationInView))")
//        } else {
//            print("BOTTOM LINE")
//            locationInView = gestureRecognizer.location(in: self.tableView)
//        }
//        print("locationInView: \(String(describing: locationInView))")
        let locationInView = gestureRecognizer.location(in: self.tableView)
        let currentIndexPath = tableView.indexPathForRow(at: locationInView)

        var center = LongPressPersistentValues.cellSnapShot?.center
        center?.y = locationInView.y
        LongPressPersistentValues.cellSnapShot?.center = center!
        if (currentIndexPath != nil) && (currentIndexPath != LongPressPersistentValues.indexPath) {
            move(from: LongPressPersistentValues.indexPath!, to: currentIndexPath!)
            LongPressPersistentValues.gestureLocationBeforeMovingRow = gestureRecognizer.location(in: self.tableView)
            print("\nBEFORE gestureRecognizer.location: \(gestureRecognizer.location(in: self.tableView))")
            tableView.moveRow(at: LongPressPersistentValues.indexPath!, to: currentIndexPath!)
            print("AFTER gestureRecognizer.location: \(gestureRecognizer.location(in: self.tableView))")
            LongPressPersistentValues.indexPath = currentIndexPath
        }
    }
    
    func handleLongPressEnded() {
        let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
        hapticGenerator.impactOccurred()
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
