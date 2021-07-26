//
//  PlanFeatures.swift
//  
//
//  Created by Igor Leonovich on 26.07.21
//  Copyright © 2021 FT. All rights reserved.
//

import Foundation

enum PlanFeatures: String, Codable {
    case plan
    case actionsPoints, dates, byTime, byTopic, byX, levels
    case fullTreeView
    
    func requiredFeatures() -> [PlanPlugin] {
        switch self {
        case .plan:
            return [.plan]
        case .actionsPoints:
            return [.plan]
        case .dates:
            return [.plan]
        case .byTime:
            return [.plan, .byX]
        case .byTopic:
            return [.plan, .byX]
        case .byX:
            return [.plan]
        case .levels:
            return [.plan]
        case .fullTreeView:
            return [.plan]
        }
    }
}
