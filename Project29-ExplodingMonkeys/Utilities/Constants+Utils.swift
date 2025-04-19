//  File: Constants+Utils.swift
//  Project: Project29-ExplodingMonkeys
//  Created by: Noah Pope on 4/9/25.

import Foundation

enum CollisionTypes: UInt32
{
    /** raw values for physics body bitmasks should be integers that are double the value of the previous case */
    case banana     = 1
    case building   = 2
    case player     = 4
}

enum UIToggleModes { case on, off }

enum NameKeys
{
    static let building = "building"
    static let player   = "player"
    static let banana   = "banana"
    static let player1  = "player1"
    static let player2  = "player2"
    static let gameOver = "gameOver"
}

enum ImageKeys
{
    static let player       = "player"
    static let banana       = "banana"
    static let player1Throw = "player1Throw"
    static let player2Throw = "player2Throw"
    static let gameOver     = "gameOver"
}

enum EmitterKeys
{
    static let hitPlayer    = "hitPlayer"
    static let hitBuilding  = "hitBuilding"
}

enum UIKeys
{
    static let activatePlayer1  = "<<< PLAYER ONE"
    static let activatePlayer2  = "PLAYER TWO >>>"
}

enum FontKeys
{
    static let chalkDuster  = "chalkDuster"
}
