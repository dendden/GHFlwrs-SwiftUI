//
//  Date-Formats.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 03.05.2023.
//

import Foundation

extension Date {

    /// Formatted presentation of `Date`: e.g. **Jan 2018**.
    var shortMonthAndYear: String {

        self.formatted(
            .dateTime
                .month()
                .year()
        )
    }
}
