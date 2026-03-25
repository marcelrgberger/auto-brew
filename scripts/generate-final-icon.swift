#!/usr/bin/env swift
import AppKit
import CoreGraphics

let size = 1024
let canvas = CGFloat(size)
let outputURL = URL(fileURLWithPath: "/Users/marcelrgberger/Developer/projects/auto-brew/AutoBrew/Assets.xcassets/AppIcon.appiconset/icon_source_1024.png")

func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
}

func drawLinearGradient(_ context: CGContext, in rect: CGRect, colors: [CGColor], locations: [CGFloat], start: CGPoint, end: CGPoint) {
    let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locations)!
    context.saveGState()
    context.addRect(rect)
    context.clip()
    context.drawLinearGradient(gradient, start: start, end: end, options: [])
    context.restoreGState()
}

func drawRadialGradient(_ context: CGContext, in rect: CGRect, colors: [CGColor], locations: [CGFloat], startCenter: CGPoint, startRadius: CGFloat, endCenter: CGPoint, endRadius: CGFloat) {
    let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locations)!
    context.saveGState()
    context.addRect(rect)
    context.clip()
    context.drawRadialGradient(gradient, startCenter: startCenter, startRadius: startRadius, endCenter: endCenter, endRadius: endRadius, options: [])
    context.restoreGState()
}

func roundedRectPath(_ rect: CGRect, radius: CGFloat) -> CGPath {
    CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil)
}

func foamPath(in rect: CGRect) -> CGPath {
    let path = CGMutablePath()
    let minX = rect.minX
    let maxX = rect.maxX
    let minY = rect.minY
    let maxY = rect.maxY
    let midX = rect.midX

    path.move(to: CGPoint(x: minX + rect.width * 0.04, y: minY + rect.height * 0.18))
    path.addCurve(
        to: CGPoint(x: minX + rect.width * 0.20, y: maxY - rect.height * 0.08),
        control1: CGPoint(x: minX - rect.width * 0.02, y: minY + rect.height * 0.56),
        control2: CGPoint(x: minX + rect.width * 0.05, y: maxY + rect.height * 0.02)
    )
    path.addCurve(
        to: CGPoint(x: midX, y: maxY - rect.height * 0.02),
        control1: CGPoint(x: minX + rect.width * 0.30, y: maxY + rect.height * 0.10),
        control2: CGPoint(x: midX - rect.width * 0.12, y: maxY + rect.height * 0.10)
    )
    path.addCurve(
        to: CGPoint(x: maxX - rect.width * 0.20, y: maxY - rect.height * 0.08),
        control1: CGPoint(x: midX + rect.width * 0.12, y: maxY + rect.height * 0.08),
        control2: CGPoint(x: maxX - rect.width * 0.30, y: maxY + rect.height * 0.10)
    )
    path.addCurve(
        to: CGPoint(x: maxX - rect.width * 0.04, y: minY + rect.height * 0.20),
        control1: CGPoint(x: maxX - rect.width * 0.06, y: maxY + rect.height * 0.02),
        control2: CGPoint(x: maxX + rect.width * 0.02, y: minY + rect.height * 0.58)
    )
    path.addCurve(
        to: CGPoint(x: maxX - rect.width * 0.10, y: minY + rect.height * 0.06),
        control1: CGPoint(x: maxX - rect.width * 0.02, y: minY + rect.height * 0.06),
        control2: CGPoint(x: maxX - rect.width * 0.06, y: minY - rect.height * 0.02)
    )
    path.addLine(to: CGPoint(x: minX + rect.width * 0.10, y: minY + rect.height * 0.06))
    path.addCurve(
        to: CGPoint(x: minX + rect.width * 0.04, y: minY + rect.height * 0.18),
        control1: CGPoint(x: minX + rect.width * 0.04, y: minY - rect.height * 0.02),
        control2: CGPoint(x: minX + rect.width * 0.00, y: minY + rect.height * 0.06)
    )
    path.closeSubpath()
    return path
}

func arrowHandlePath(center: CGPoint, radius: CGFloat, thickness: CGFloat) -> CGPath {
    let startAngle = CGFloat.pi * 0.20
    let endAngle = -CGFloat.pi * 1.15
    let tipAngle = CGFloat.pi * 0.22

    let outerRadius = radius + thickness / 2
    let innerRadius = radius - thickness / 2

    let path = CGMutablePath()
    path.addArc(center: center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    path.addArc(center: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
    path.closeSubpath()

    let tip = CGPoint(x: center.x + cos(tipAngle) * outerRadius, y: center.y + sin(tipAngle) * outerRadius)
    let tangentAngle = tipAngle - .pi / 2
    let arrowLength = thickness * 1.15
    let arrowWidth = thickness * 0.95

    let base = CGPoint(
        x: center.x + cos(tipAngle) * (radius + thickness * 0.04),
        y: center.y + sin(tipAngle) * (radius + thickness * 0.04)
    )
    let left = CGPoint(
        x: base.x - cos(tangentAngle) * arrowWidth * 0.5 - cos(tipAngle) * arrowLength * 0.45,
        y: base.y - sin(tangentAngle) * arrowWidth * 0.5 - sin(tipAngle) * arrowLength * 0.45
    )
    let right = CGPoint(
        x: base.x + cos(tangentAngle) * arrowWidth * 0.5 - cos(tipAngle) * arrowLength * 0.45,
        y: base.y + sin(tangentAngle) * arrowWidth * 0.5 - sin(tipAngle) * arrowLength * 0.45
    )

    path.move(to: tip)
    path.addLine(to: left)
    path.addLine(to: right)
    path.closeSubpath()

    return path
}

let rep = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: size,
    pixelsHigh: size,
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: .deviceRGB,
    bytesPerRow: 0,
    bitsPerPixel: 0
)!

let graphicsContext = NSGraphicsContext(bitmapImageRep: rep)!
NSGraphicsContext.current = graphicsContext
let context = graphicsContext.cgContext

let fullRect = CGRect(x: 0, y: 0, width: canvas, height: canvas)

drawLinearGradient(
    context,
    in: fullRect,
    colors: [rgb(25, 32, 42), rgb(9, 13, 20)],
    locations: [0, 1],
    start: CGPoint(x: 0, y: canvas),
    end: CGPoint(x: canvas, y: 0)
)

drawRadialGradient(
    context,
    in: fullRect,
    colors: [rgb(255, 176, 62, 0.40), rgb(255, 176, 62, 0.05), rgb(255, 176, 62, 0.0)],
    locations: [0, 0.55, 1],
    startCenter: CGPoint(x: canvas * 0.48, y: canvas * 0.58),
    startRadius: 0,
    endCenter: CGPoint(x: canvas * 0.48, y: canvas * 0.58),
    endRadius: canvas * 0.55
)

let mugRect = CGRect(x: 252, y: 202, width: 420, height: 520)
let mugPath = roundedRectPath(mugRect, radius: 88)
let innerInset: CGFloat = 28
let beerRect = mugRect.insetBy(dx: innerInset, dy: innerInset + 6)
let beerPath = roundedRectPath(beerRect, radius: 66)

context.saveGState()
context.setShadow(offset: CGSize(width: 0, height: -26), blur: 54, color: rgb(0, 0, 0, 0.30))
context.addPath(mugPath)
context.setFillColor(rgb(248, 249, 252, 0.97))
context.fillPath()
context.restoreGState()

context.saveGState()
context.addPath(beerPath)
context.clip()
drawLinearGradient(
    context,
    in: beerRect,
    colors: [rgb(255, 207, 86), rgb(240, 147, 29), rgb(169, 78, 17)],
    locations: [0, 0.58, 1],
    start: CGPoint(x: beerRect.midX, y: beerRect.maxY),
    end: CGPoint(x: beerRect.midX, y: beerRect.minY)
)
drawRadialGradient(
    context,
    in: beerRect,
    colors: [rgb(255, 240, 176, 0.36), rgb(255, 240, 176, 0.0)],
    locations: [0, 1],
    startCenter: CGPoint(x: beerRect.minX + beerRect.width * 0.30, y: beerRect.maxY - beerRect.height * 0.16),
    startRadius: 0,
    endCenter: CGPoint(x: beerRect.minX + beerRect.width * 0.30, y: beerRect.maxY - beerRect.height * 0.16),
    endRadius: beerRect.width * 0.7
)
context.restoreGState()

let foamRect = CGRect(x: mugRect.minX - 20, y: mugRect.maxY - 38, width: mugRect.width + 40, height: 176)
let foam = foamPath(in: foamRect)
context.saveGState()
context.setShadow(offset: CGSize(width: 0, height: -10), blur: 24, color: rgb(255, 255, 255, 0.14))
context.addPath(foam)
context.setFillColor(rgb(255, 250, 240, 0.98))
context.fillPath()
context.restoreGState()

context.saveGState()
context.addPath(foam)
context.clip()
drawLinearGradient(
    context,
    in: foamRect,
    colors: [rgb(255, 255, 255, 0.95), rgb(238, 229, 214, 0.92)],
    locations: [0, 1],
    start: CGPoint(x: foamRect.midX, y: foamRect.maxY),
    end: CGPoint(x: foamRect.midX, y: foamRect.minY)
)
drawRadialGradient(
    context,
    in: foamRect,
    colors: [rgb(255, 255, 255, 0.55), rgb(255, 255, 255, 0.0)],
    locations: [0, 1],
    startCenter: CGPoint(x: foamRect.minX + foamRect.width * 0.36, y: foamRect.maxY - 18),
    startRadius: 0,
    endCenter: CGPoint(x: foamRect.minX + foamRect.width * 0.36, y: foamRect.maxY - 18),
    endRadius: foamRect.width * 0.44
)
context.restoreGState()

let handleCenter = CGPoint(x: mugRect.maxX + 34, y: mugRect.midY + 36)
let handle = arrowHandlePath(center: handleCenter, radius: 125, thickness: 82)
context.saveGState()
context.setShadow(offset: CGSize(width: 0, height: -18), blur: 40, color: rgb(0, 0, 0, 0.24))
context.addPath(handle)
context.setFillColor(rgb(247, 186, 71, 0.98))
context.fillPath()
context.restoreGState()

context.saveGState()
context.addPath(handle)
context.clip()
let handleBounds = CGRect(x: handleCenter.x - 220, y: handleCenter.y - 220, width: 440, height: 440)
drawLinearGradient(
    context,
    in: handleBounds,
    colors: [rgb(255, 221, 110), rgb(222, 130, 28), rgb(154, 76, 16)],
    locations: [0, 0.65, 1],
    start: CGPoint(x: handleBounds.minX, y: handleBounds.maxY),
    end: CGPoint(x: handleBounds.maxX, y: handleBounds.minY)
)
context.restoreGState()

context.saveGState()
context.addPath(mugPath)
context.setStrokeColor(rgb(255, 255, 255, 0.16))
context.setLineWidth(8)
context.strokePath()
context.restoreGState()

let glassHighlight = CGMutablePath()
glassHighlight.move(to: CGPoint(x: mugRect.minX + 58, y: mugRect.minY + 92))
glassHighlight.addCurve(
    to: CGPoint(x: mugRect.minX + 114, y: mugRect.maxY - 72),
    control1: CGPoint(x: mugRect.minX + 46, y: mugRect.minY + 248),
    control2: CGPoint(x: mugRect.minX + 74, y: mugRect.maxY - 180)
)
context.saveGState()
context.addPath(mugPath)
context.clip()
context.addPath(glassHighlight)
context.setStrokeColor(rgb(255, 255, 255, 0.24))
context.setLineWidth(34)
context.setLineCap(.round)
context.strokePath()
context.restoreGState()

drawRadialGradient(
    context,
    in: fullRect,
    colors: [rgb(255, 255, 255, 0.18), rgb(255, 255, 255, 0.0)],
    locations: [0, 1],
    startCenter: CGPoint(x: 250, y: 856),
    startRadius: 0,
    endCenter: CGPoint(x: 250, y: 856),
    endRadius: 240
)

NSGraphicsContext.current = nil

guard let pngData = rep.representation(using: .png, properties: [:]) else {
    fputs("Failed to encode PNG\n", stderr)
    exit(1)
}

do {
    try FileManager.default.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
    try pngData.write(to: outputURL)
    print("Wrote \(outputURL.path)")
} catch {
    fputs("Failed to write icon: \(error)\n", stderr)
    exit(1)
}
