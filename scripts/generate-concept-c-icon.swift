#!/usr/bin/env swift

import AppKit

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: r, green: g, blue: b, alpha: a)
}

func generateIcon(pixels: Int) -> Data? {
    let p = CGFloat(pixels)
    let center = CGPoint(x: p / 2, y: p / 2)

    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
    )!

    let ctx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = ctx
    let g = ctx.cgContext

    // 1. BACKGROUND — Gradient from #0D4A3A (top-left) to #062318 (bottom-right)
    let bgGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.051, 0.290, 0.227), // #0D4A3A
        color(0.024, 0.137, 0.094), // #062318
    ] as CFArray, locations: [0.0, 1.0])!
    
    g.drawLinearGradient(bgGrad, start: CGPoint(x: 0, y: p), end: CGPoint(x: p, y: 0), options: [])

    // 2. BEER GLASS SILHOUETTE (Concept C)
    let creamColor = color(0.961, 0.941, 0.910) // #F5F0E8
    let greenColor = color(0.290, 0.871, 0.502) // #4ADE80
    
    g.setFillColor(creamColor)
    
    let mugWidth = p * 0.45
    let mugHeight = p * 0.55
    let mugX = center.x - mugWidth * 0.5 - p * 0.05 // Offset a bit to balance the handle
    let mugY = center.y - mugHeight * 0.4
    
    // Main body
    let bodyPath = CGMutablePath()
    let cornerRadius = p * 0.06
    bodyPath.addRoundedRect(in: CGRect(x: mugX, y: mugY, width: mugWidth, height: mugHeight), cornerWidth: cornerRadius, cornerHeight: cornerRadius)
    g.addPath(bodyPath)
    g.fillPath()
    
    // Handle
    let handleWidth = p * 0.18
    let handleHeight = p * 0.35
    let handleX = mugX + mugWidth - p * 0.02
    let handleY = mugY + mugHeight * 0.15
    let handlePath = CGMutablePath()
    handlePath.addRoundedRect(in: CGRect(x: handleX, y: handleY, width: handleWidth, height: handleHeight), cornerWidth: p * 0.08, cornerHeight: p * 0.08)
    
    // Cutout for handle
    let cutoutWidth = handleWidth * 0.5
    let cutoutHeight = handleHeight * 0.6
    let cutoutX = handleX + (handleWidth - cutoutWidth) * 0.4
    let cutoutY = handleY + (handleHeight - cutoutHeight) * 0.5
    handlePath.addRoundedRect(in: CGRect(x: cutoutX, y: cutoutY, width: cutoutWidth, height: cutoutHeight), cornerWidth: p * 0.04, cornerHeight: p * 0.04)
    
    g.addPath(handlePath)
    g.fillPath(using: .evenOdd)
    
    // Foam (top)
    let foamWidth = mugWidth * 1.1
    let foamHeight = p * 0.12
    let foamX = mugX - (foamWidth - mugWidth) * 0.5
    let foamY = mugY + mugHeight - p * 0.03
    let foamPath = CGMutablePath()
    foamPath.addRoundedRect(in: CGRect(x: foamX, y: foamY, width: foamWidth, height: foamHeight), cornerWidth: p * 0.06, cornerHeight: p * 0.06)
    g.addPath(foamPath)
    g.fillPath()

    // 3. REFRESH ARROW — Overlapping at the bottom-right corner
    let ringRadius = p * 0.14
    let ringThickness = p * 0.05
    let ringCenter = CGPoint(x: mugX + mugWidth * 0.9, y: mugY + p * 0.05)
    
    // Clear a space for the arrow (knockout)
    g.saveGState()
    g.setBlendMode(.clear)
    g.addArc(center: ringCenter, radius: ringRadius + ringThickness * 0.5 + p * 0.02, startAngle: 0, endAngle: .pi * 2, clockwise: false)
    g.fillPath()
    g.restoreGState()
    
    // Draw the arrow
    g.setStrokeColor(greenColor)
    g.setFillColor(greenColor)
    g.setLineWidth(ringThickness)
    g.setLineCap(.round)
    
    let startAngle = -CGFloat.pi * 0.1
    let endAngle = CGFloat.pi * 1.6
    let ringPath = CGMutablePath()
    ringPath.addArc(center: ringCenter, radius: ringRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
    g.addPath(ringPath)
    g.strokePath()
    
    // Arrowhead
    let arrowSize = p * 0.07
    let arrowAngle = endAngle
    let arrowPos = CGPoint(x: ringCenter.x + ringRadius * cos(arrowAngle), y: ringCenter.y + ringRadius * sin(arrowAngle))
    
    g.saveGState()
    g.translateBy(x: arrowPos.x, y: arrowPos.y)
    g.rotate(by: arrowAngle)
    
    let arrowPath = CGMutablePath()
    arrowPath.move(to: CGPoint(x: 0, y: 0))
    arrowPath.addLine(to: CGPoint(x: -arrowSize, y: arrowSize * 0.7))
    arrowPath.addLine(to: CGPoint(x: -arrowSize, y: -arrowSize * 0.7))
    arrowPath.closeSubpath()
    
    g.addPath(arrowPath)
    g.fillPath()
    g.restoreGState()

    NSGraphicsContext.current = nil
    return rep.representation(using: .png, properties: [:])
}

let outputDir = "AutoBrew/Assets.xcassets/AppIcon.appiconset"
let sizes: [(Int, String)] = [
    (16, "icon_16x16.png"), (32, "icon_16x16@2x.png"),
    (32, "icon_32x32.png"), (64, "icon_32x32@2x.png"),
    (128, "icon_128x128.png"), (256, "icon_128x128@2x.png"),
    (256, "icon_256x256.png"), (512, "icon_256x256@2x.png"),
    (512, "icon_512x512.png"), (1024, "icon_512x512@2x.png"),
    (1024, "icon_source_1024.png"),
]

for (px, name) in sizes {
    guard let png = generateIcon(pixels: px) else { print("FAIL: \(name)"); continue }
    let url = URL(fileURLWithPath: "\(outputDir)/\(name)")
    try! png.write(to: url)
    print("\(name) (\(px)px)")
}

print("\nSuccessfully generated Concept C icons in \(outputDir)")
