//
//  DeftLog.swift
//  Centralized log level configuration
//
//  Created by Kit Transue on 2021-06-06.
//  Copyright © 2021 Kit Transue.
//  SPDX-License-Identifier: Apache-2.0
//

import Logging

public class DeftLog {
    // FIXME: have prefix actually be a regex pattern.
    // FIXME: have these be anonymous tuples? Or an array of structures?
    // Trying tuple to reduce verbosity of the setup:
    public static var settings: [(prefix: String, level: Logger.Level)] = []

    public static func logger(label: String) -> Logger {
        var logObject = Logger(label: label)

        if let match = settings.first(where: { (prefix: String, level: Logger.Level) in
            label.starts(with: prefix)
        }) {
            logObject.logLevel = match.level
        }

        return logObject
    }
}
