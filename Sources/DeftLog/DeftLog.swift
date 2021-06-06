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
    public static func logger(label: String) -> Logger {
        var logObject = Logger(label: label)
        // FIXME: look up log level in table

        // default log level .info
        logObject.logLevel = .info
        return logObject
    }
}
