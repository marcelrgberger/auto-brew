#!/usr/bin/env swift

import AppKit

let icons: [(pixels: Int, filename: String)] = [
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

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: r, green: g, blue: b, alpha: a)
}

func generateIcon(pixels: Int) -> Data? {
    let px = CGFloat(pixels)

    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: pixels,
        pixelsHigh: pixels,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!

    let ctx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = ctx
    let g = ctx.cgContext
    let p = px

    // --- Rounded rect background ---
    let corner = p * 0.22
    let bgPath = CGPath(roundedRect: CGRect(x: 0, y: 0, width: p, height: p), cornerWidth: corner, cornerHeight: corner, transform: nil)

    g.saveGState()
    g.addPath(bgPath)
    g.clip()
    let bgGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.75, 0.45, 0.15),
        color(0.35, 0.18, 0.05),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(bgGrad, start: CGPoint(x: p * 0.2, y: p), end: CGPoint(x: p * 0.8, y: 0), options: [])
    g.restoreGState()

    // --- Inner glow ---
    g.saveGState()
    g.addPath(bgPath)
    g.clip()
    let glowGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1, 1, 1, 0.12),
        color(1, 1, 1, 0.0),
    ] as CFArray, locations: [0.0, 0.5])!
    g.drawRadialGradient(glowGrad, startCenter: CGPoint(x: p * 0.35, y: p * 0.7), startRadius: 0, endCenter: CGPoint(x: p * 0.5, y: p * 0.5), endRadius: p * 0.6, options: [])
    g.restoreGState()

    // --- Mug body ---
    let mugL = p * 0.2, mugB = p * 0.18, mugW = p * 0.38, mugH = p * 0.48
    let mugR = p * 0.07
    let mugRect = CGRect(x: mugL, y: mugB, width: mugW, height: mugH)
    let mugPath = CGPath(roundedRect: mugRect, cornerWidth: mugR, cornerHeight: mugR, transform: nil)

    g.saveGState()
    g.addPath(mugPath)
    g.clip()
    let mugGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1, 1, 1, 0.95),
        color(0.92, 0.92, 0.92, 0.95),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(mugGrad, start: CGPoint(x: 0, y: mugB + mugH), end: CGPoint(x: 0, y: mugB), options: [])
    g.restoreGState()

    // --- Handle ---
    let hx = mugL + mugW, hy = mugB + mugH * 0.48, hr = p * 0.095
    g.setStrokeColor(color(1, 1, 1, 0.92))
    g.setLineWidth(p * 0.04)
    g.setLineCap(.round)
    let handle = CGMutablePath()
    handle.addArc(center: CGPoint(x: hx, y: hy), radius: hr, startAngle: -.pi / 2.2, endAngle: .pi / 2.2, clockwise: true)
    g.addPath(handle)
    g.strokePath()

    // --- Steam ---
    g.setStrokeColor(color(1, 1, 1, 0.4))
    g.setLineWidth(p * 0.018)
    g.setLineCap(.round)
    let sBase = mugB + mugH + p * 0.035, sH = p * 0.13
    for (i, x) in [mugL + mugW * 0.3, mugL + mugW * 0.55, mugL + mugW * 0.8].enumerated() {
        let w = p * 0.022 * (i % 2 == 0 ? 1.0 : -1.0)
        let s = CGMutablePath()
        s.move(to: CGPoint(x: x, y: sBase))
        s.addCurve(to: CGPoint(x: x + w * 0.5, y: sBase + sH),
                   control1: CGPoint(x: x + w, y: sBase + sH * 0.35),
                   control2: CGPoint(x: x - w, y: sBase + sH * 0.65))
        g.addPath(s)
        g.strokePath()
    }

    // --- Green badge ---
    let bSz = p * 0.26, bX = p * 0.66, bY = p * 0.08
    let bC = CGPoint(x: bX + bSz / 2, y: bY + bSz / 2)

    g.saveGState()
    g.setShadow(offset: CGSize(width: 0, height: -p * 0.008), blur: p * 0.02, color: color(0, 0, 0, 0.3))
    g.setFillColor(color(0.22, 0.78, 0.40))
    g.fillEllipse(in: CGRect(x: bX, y: bY, width: bSz, height: bSz))
    g.restoreGState()

    g.saveGState()
    g.addEllipse(in: CGRect(x: bX, y: bY, width: bSz, height: bSz))
    g.clip()
    let bGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.30, 0.85, 0.48),
        color(0.15, 0.65, 0.30),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(bGrad, start: CGPoint(x: bX, y: bY + bSz), end: CGPoint(x: bX, y: bY), options: [])
    g.restoreGState()

    // Badge arrows
    let aR = bSz * 0.28, aLW = p * 0.022
    g.setStrokeColor(color(1, 1, 1, 0.95))
    g.setLineWidth(aLW)
    g.setLineCap(.round)

    for start: CGFloat in [0.2, 1.2] {
        let arc = CGMutablePath()
        arc.addArc(center: bC, radius: aR, startAngle: .pi * start, endAngle: .pi * (start + 0.6), clockwise: false)
        g.addPath(arc)
        g.strokePath()
    }

    // Arrow tips
    let tL = p * 0.032
    for angle: CGFloat in [0.8, 1.8] {
        let pt = CGPoint(x: bC.x + aR * cos(.pi * angle), y: bC.y + aR * sin(.pi * angle))
        let dir = .pi * angle + .pi / 2
        g.setFillColor(color(1, 1, 1, 0.95))
        let tip = CGMutablePath()
        tip.move(to: pt)
        tip.addLine(to: CGPoint(x: pt.x + tL * cos(dir + 2.3), y: pt.y + tL * sin(dir + 2.3)))
        tip.addLine(to: CGPoint(x: pt.x + tL * cos(dir - 2.3), y: pt.y + tL * sin(dir - 2.3)))
        tip.closeSubpath()
        g.addPath(tip)
        g.fillPath()
    }

    NSGraphicsContext.current = nil
    return rep.representation(using: .png, properties: [:])
}

for icon in icons {
    guard let png = generateIcon(pixels: icon.pixels) else {
        print("Failed: \(icon.filename)")
        continue
    }
    let path = "\(outputDir)/\(icon.filename)"
    try! png.write(to: URL(fileURLWithPath: path))
    print("Generated \(icon.filename) (\(icon.pixels)x\(icon.pixels) px)")
}

print("\nDone!")
