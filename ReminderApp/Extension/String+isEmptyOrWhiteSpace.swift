//
//  String+isEmptyOrWhiteSpace.swift
//  ReminderApp
//
//

import Foundation

extension String { var isEmptyOrWhitespace: Bool { return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } }
