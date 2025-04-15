//  File: Constants+Utils.swift
//  Project: Project29-ExplodingMonkeys
//  Created by: Noah Pope on 4/9/25.

import Foundation

enum CollisionTypes: UInt32
{
    case banana     = 1
    case building   = 2
    case player     = 4
}

enum UIToggleModes { case on, off }

enum NameKeys
{
    static let building = "building"
}

enum ImageKeys
{
    static let player       = "player"
    static let banana       = "banana"
    static let player1Throw = "player1Throw"
    static let player2Throw = "player2Throw"
}
