//
//  Grid.swift
//  Tic-Toc-Game
//
//  Created by 周越 on 2/6/22.
//

import Foundation

class Grid {
    
    let winner = [[0,3,6],[1,4,7],[2,5,8],[0,1,2],[3,4,5],[6,7,8],[0,4,8],[2,4,6]]
    
    var grid: [Int]
    var gameActive: Bool
    
    var patternX: [Int]
    var patternO: [Int]
    
    init() {
        grid = [0,0,0,0,0,0,0,0,0]
        gameActive = true
        patternX = []
        patternO = []
    }
    
    func reset() {
        grid = [0,0,0,0,0,0,0,0,0]
        gameActive = true
        patternX = []
        patternO = []
    }
    
    func checkEmpty(_ pos:Int) -> Bool {
        if grid[pos] == 0 {
            return true
        }
        else {
            return false
        }
    }
    
    func checkWin(_ pattern:[Int])->Bool {
        for win in winner {
            if pattern.sorted() == win || Set(win).isSubset(of:pattern) {
                gameActive = false
                return true
            }
        }
        return false
    }
    
    func occupyGrid(_ index:Int) {
        grid[index] = 1
    }
    
    
    func checkTie() -> Bool {
        if grid == [1,1,1,1,1,1,1,1,1] {
            gameActive = false
            return true
        }
        else {
            return false
        }
    }
    
}
