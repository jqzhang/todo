//
//  NotificationData.swift
//  ToDo
//
//  Created by Vii on 2023/8/2.
//

import SwiftUI
import Combine

class NotificationData: ObservableObject {
    @Published var data: [AnyHashable: Any]?

    init() { }
}
