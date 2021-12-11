//
//  main.swift
//  No rights reserved.
//

import Foundation
import RegexHelper
import AppKit

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }

    var energyLevels = lines.map { line in
        return Array(line).map { Int(String($0))! }
    }
    var totalFlashes = 0
    let totalOctopuses = energyLevels[0].count * energyLevels.count
    var allFlashed = false
    var i = 0

    while !allFlashed {
        i += 1
        let (levels, flashes) = runStep(initialEnergyLevels: energyLevels)
        energyLevels = levels
        if flashes == totalOctopuses {
            allFlashed = true
            print("Part 2: \(i)")
        }
        totalFlashes += flashes
        if i == 100 {
            print("Part 1: \(totalFlashes)")
        }
    }
}

func runStep(initialEnergyLevels: [[Int]]) -> ([[Int]], Int) {
    var energyLevels = initialEnergyLevels
    var pointsToAddress = [(x: Int, y: Int)]()
    var pointsToNullify = [(x: Int, y: Int)]()
    var flashes = 0

    for i in 0 ..< energyLevels[0].count {
        for j in 0 ..< energyLevels.count {
            energyLevels[i][j] += 1
            if energyLevels[i][j] > 9 {
                pointsToAddress.append((x: i, y: j))
                flashes += 1
            }
        }
    }

    while !pointsToAddress.isEmpty {
        let point = pointsToAddress.removeFirst()
        for i in max(point.x - 1, 0) ... min(point.x + 1, energyLevels[0].count - 1) {
            for j in max(point.y - 1, 0) ... min(point.y + 1, energyLevels.count - 1) {
                energyLevels[i][j] += 1
                if energyLevels[i][j] == 10 {
                    if !pointsToAddress.contains(where: { $0.x == i && $0.y == j }) {
                        pointsToAddress.append((x: i, y: j))
                        flashes += 1
                    }
                }
            }
        }
        pointsToNullify.append(point)
    }
    pointsToNullify.forEach { point in
        energyLevels[point.x][point.y] = 0
    }

    return (energyLevels, flashes)
}

main()
