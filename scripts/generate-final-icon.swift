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

func clockHandlePath(center: CGPoint, radius: CGFloat, bezelThickness: CGFloat, connectorWidth: CGFloat, connectorHeight: CGFloat) -> CGPath {
    let outerRadius = radius + bezelThickness / 2
    let connectorRect = CGRect(
        x: center.x - outerRadius - connectorWidth * 0.62,
        y: center.y - connectorHeight / 2,
        width: connectorWidth,
        height: connectorHeight
    )

    let path = CGMutablePath()
    path.addPath(CGPath(ellipseIn: CGRect(
        x: center.x - outerRadius,
        y: center.y - outerRadius,
        width: outerRadius * 2,
        height: outerRadius * 2
    ), transform: nil))
    path.addPath(roundedRectPath(connectorRect, radius: connectorHeight * 0.48))
    return path
}

func clockFacePath(center: CGPoint, radius: CGFloat) -> CGPath {
    CGPath(ellipseIn: CGRect(
        x: center.x - radius,
        y: center.y - radius,
        width: radius * 2,
        height: radius * 2
    ), transform: nil)
}

func clockHandsPath(center: CGPoint, radius: CGFloat) -> CGPath {
    let path = CGMutablePath()

    path.move(to: center)
    path.addLine(to: CGPoint(
        x: center.x,
        y: center.y + radius * 0.48
    ))

    let minuteAngle = -CGFloat.pi * 0.18
    path.move(to: center)
    path.addLine(to: CGPoint(
        x: center.x + cos(minuteAngle) * radius * 0.60,
        y: center.y + sin(minuteAngle) * radius * 0.60
    ))

    path.addEllipse(in: CGRect(x: center.x - radius * 0.09, y: center.y - radius * 0.09, width: radius * 0.18, height: radius * 0.18))
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

let handleCenter = CGPoint(x: mugRect.maxX + 118, y: mugRect.midY + 38)
let handle = clockHandlePath(center: handleCenter, radius: 98, bezelThickness: 58, connectorWidth: 122, connectorHeight: 130)
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

let clockFace = clockFacePath(center: handleCenter, radius: 70)
context.saveGState()
context.setShadow(offset: CGSize(width: 0, height: -8), blur: 18, color: rgb(255, 255, 255, 0.10))
context.addPath(clockFace)
context.setFillColor(rgb(255, 247, 228, 0.96))
context.fillPath()
context.restoreGState()

context.saveGState()
context.addPath(clockFace)
context.clip()
let clockFaceBounds = CGRect(x: handleCenter.x - 84, y: handleCenter.y - 84, width: 168, height: 168)
drawLinearGradient(
    context,
    in: clockFaceBounds,
    colors: [rgb(255, 252, 244, 0.98), rgb(242, 228, 196, 0.95)],
    locations: [0, 1],
    start: CGPoint(x: clockFaceBounds.minX, y: clockFaceBounds.maxY),
    end: CGPoint(x: clockFaceBounds.maxX, y: clockFaceBounds.minY)
)
context.restoreGState()

context.saveGState()
context.addPath(clockFace)
context.setStrokeColor(rgb(255, 255, 255, 0.32))
context.setLineWidth(6)
context.strokePath()
context.restoreGState()

let clockHands = clockHandsPath(center: handleCenter, radius: 58)
context.saveGState()
context.addPath(clockHands)
context.setStrokeColor(rgb(88, 66, 32, 0.92))
context.setLineWidth(15)
context.setLineCap(.round)
context.setLineJoin(.round)
context.strokePath()
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
