//
//  Globals.swift
//  OpenSooqTask
//
//  Created by Qais Alnammari on 7/8/19.
//  Copyright © 2019 Qais Alnammari. All rights reserved.
//

import Foundation

func localized(localizeKey: LocalizationKeys ,  comment: String = "") -> String{
    return  NSLocalizedString(localizeKey.rawValue, comment: comment)
}
