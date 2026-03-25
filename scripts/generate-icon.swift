#!/usr/bin/env swift

import AppKit

let sizes: [(CGFloat, String)] = [
    (16, "icon_16x16.png"),
    (32, "icon_16x16@2x.png"),
    (32, "icon_32x32.png"),
    (64, "icon_32x32@2x.png"),
    (128, "icon_128x128.png"),
    (256, "icon_128x128@2x.png"),
    (256, "icon_256x256.png"),
    (512, "icon_256x256@2x.png"),
    (512, "icon_512x512.png"),
    (1024, "icon_512x512@2x.png"),
]

let outputDir = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "AutoBrew/Assets.xcassets/AppIcon.appiconset"

func generateIcon(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    guard let ctx = NSGraphicsContext.current?.cgContext else {
        image.unlockFocus()
        return image
    }

    let s = size

    // --- Rounded rect background with warm brown gradient ---
    let cornerRadius = s * 0.22
    let bgRect = CGRect(x: 0, y: 0, width: s, height: s)
    let bgPath = CGPath(roundedRect: bgRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)

    ctx.saveGState()
    ctx.addPath(bgPath)
    ctx.clip()

    let bgColors = [
        CGColor(red: 0.52, green: 0.30, blue: 0.12, alpha: 1.0),
        CGColor(red: 0.32, green: 0.16, blue: 0.06, alpha: 1.0),
    ]
    let bgGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: bgColors as CFArray, locations: [0.0, 1.0])!
    ctx.drawLinearGradient(bgGradient, start: CGPoint(x: 0, y: s), end: CGPoint(x: 0, y: 0), options: [])
    ctx.restoreGState()

    // --- Mug body ---
    let mugLeft = s * 0.18
    let mugBottom = s * 0.18
    let mugWidth = s * 0.42
    let mugHeight = s * 0.52
    let mugCorner = s * 0.06
    let mugRect = CGRect(x: mugLeft, y: mugBottom, width: mugWidth, height: mugHeight)
    let mugPath = CGPath(roundedRect: mugRect, cornerWidth: mugCorner, cornerHeight: mugCorner, transform: nil)

    ctx.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.92))
    ctx.addPath(mugPath)
    ctx.fillPath()

    // --- Mug handle (right side arc) ---
    let handleCenterX = mugLeft + mugWidth
    let handleCenterY = mugBottom + mugHeight * 0.5
    let handleOuterR = s * 0.13
    let handleInnerR = s * 0.07

    ctx.setStrokeColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.92))
    ctx.setLineWidth(s * 0.045)

    let handlePath = CGMutablePath()
    handlePath.addArc(center: CGPoint(x: handleCenterX, y: handleCenterY), radius: (handleOuterR + handleInnerR) / 2, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: true)
    ctx.addPath(handlePath)
    ctx.strokePath()

    // --- Steam lines ---
    let steamColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    ctx.setStrokeColor(steamColor)
    ctx.setLineWidth(s * 0.02)
    ctx.setLineCap(.round)

    let steamBaseY = mugBottom + mugHeight + s * 0.04
    let steamTopY = steamBaseY + s * 0.14
    let steamXPositions = [mugLeft + mugWidth * 0.25, mugLeft + mugWidth * 0.5, mugLeft + mugWidth * 0.75]

    for (i, x) in steamXPositions.enumerated() {
        let steam = CGMutablePath()
        let wave = s * 0.025 * (i % 2 == 0 ? 1.0 : -1.0)
        steam.move(to: CGPoint(x: x, y: steamBaseY))
        steam.addCurve(
            to: CGPoint(x: x, y: steamTopY),
            control1: CGPoint(x: x + wave, y: steamBaseY + (steamTopY - steamBaseY) * 0.33),
            control2: CGPoint(x: x - wave, y: steamBaseY + (steamTopY - steamBaseY) * 0.66)
        )
        ctx.addPath(steam)
        ctx.strokePath()
    }

    // --- Green refresh badge (bottom right) ---
    let badgeSize = s * 0.28
    let badgeX = s * 0.65
    let badgeY = s * 0.08
    let badgeCenter = CGPoint(x: badgeX + badgeSize / 2, y: badgeY + badgeSize / 2)

    // Badge background
    ctx.setFillColor(CGColor(red: 0.18, green: 0.72, blue: 0.33, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: badgeX, y: badgeY, width: badgeSize, height: badgeSize))

    // Circular arrow in badge
    let arrowRadius = badgeSize * 0.30
    let arrowLineWidth = s * 0.025

    ctx.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.95))
    ctx.setLineWidth(arrowLineWidth)
    ctx.setLineCap(.round)

    // Top arc
    let arc1 = CGMutablePath()
    arc1.addArc(center: badgeCenter, radius: arrowRadius, startAngle: .pi * 0.15, endAngle: .pi * 0.85, clockwise: false)
    ctx.addPath(arc1)
    ctx.strokePath()

    // Bottom arc
    let arc2 = CGMutablePath()
    arc2.addArc(center: badgeCenter, radius: arrowRadius, startAngle: .pi * 1.15, endAngle: .pi * 1.85, clockwise: false)
    ctx.addPath(arc2)
    ctx.strokePath()

    // Arrow tips
    let tipSize = s * 0.035
    func drawArrowTip(at point: CGPoint, angle: CGFloat) {
        ctx.saveGState()
        ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.95))
        let tip = CGMutablePath()
        tip.move(to: point)
        tip.addLine(to: CGPoint(x: point.x + tipSize * cos(angle + 2.5), y: point.y + tipSize * sin(angle + 2.5)))
        tip.addLine(to: CGPoint(x: point.x + tipSize * cos(angle - 2.5), y: point.y + tipSize * sin(angle - 2.5)))
        tip.closeSubpath()
        ctx.addPath(tip)
        ctx.fillPath()
        ctx.restoreGState()
    }

    let tip1 = CGPoint(
        x: badgeCenter.x + arrowRadius * cos(.pi * 0.85),
        y: badgeCenter.y + arrowRadius * sin(.pi * 0.85)
    )
    drawArrowTip(at: tip1, angle: .pi * 0.85 + .pi / 2)

    let tip2 = CGPoint(
        x: badgeCenter.x + arrowRadius * cos(.pi * 1.85),
        y: badgeCenter.y + arrowRadius * sin(.pi * 1.85)
    )
    drawArrowTip(at: tip2, angle: .pi * 1.85 + .pi / 2)

    image.unlockFocus()
    return image
}

for (size, filename) in sizes {
    let image = generateIcon(size: size)
    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let png = bitmap.representation(using: .png, properties: [:]) else {
        print("Failed to generate \(filename)")
        continue
    }

    let path = "\(outputDir)/\(filename)"
    do {
        try png.write(to: URL(fileURLWithPath: path))
        print("Generated \(filename) (\(Int(size))x\(Int(size)))")
    } catch {
        print("Failed to write \(filename): \(error)")
    }
}

print("\nAll icons generated!")
