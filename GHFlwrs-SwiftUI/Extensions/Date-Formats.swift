//
//  Date-Formats.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 03.05.2023.
//

import Foundation

extension Date {

    var shortMonthAndYear: String {

        self.formatted(
            .dateTime
                .month()
                .year()
        )
    }
}
