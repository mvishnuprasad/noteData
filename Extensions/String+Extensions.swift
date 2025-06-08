//
//  String+Extensions.swift
//  notes
//
//  Created by vishnuprasad on 08/06/25.
//

import Foundation
extension String {
    var isEmptyOrSpace : Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
