import AppKit

let p: CGFloat = 1024
let output = "AutoBrew/Assets.xcassets/AppIcon.appiconset/icon_source_1024.png"

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: r, green: g, blue: b, alpha: a)
}

func generateIcon() {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(p),
        pixelsHigh: Int(p),
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

    // 1. Background (Deep Teal to Near-Black Gradient)
    g.saveGState()
    let bgGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.0, 0.25, 0.22), // Dark Emerald/Teal
        color(0.01, 0.02, 0.02), // Near Black
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(bgGrad, start: CGPoint(x: 0, y: p), end: CGPoint(x: p, y: 0), options: [])
    g.restoreGState()

    // 2. Caustics (Subtle lighting on background)
    g.saveGState()
    g.setBlendMode(.screen)
    let causticGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.1, 0.4, 0.3, 0.3),
        color(0, 0, 0, 0)
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawRadialGradient(causticGrad, startCenter: CGPoint(x: p * 0.3, y: p * 0.4), startRadius: 0, endCenter: CGPoint(x: p * 0.3, y: p * 0.4), endRadius: p * 0.4, options: [])
    g.restoreGState()

    // 3. Beer Glass Setup
    let glassW: CGFloat = p * 0.32
    let glassH: CGFloat = p * 0.60
    let glassX = p * 0.5
    let glassY = p * 0.45
    
    g.saveGState()
    g.translateBy(x: glassX, y: glassY)
    g.rotate(by: -0.08) // Slightly tilted
    
    // Tapered Pint Glass Path
    let glassPath = CGMutablePath()
    let bottomW = glassW * 0.7
    glassPath.move(to: CGPoint(x: -bottomW/2, y: -glassH/2))
    glassPath.addLine(to: CGPoint(x: -glassW/2, y: glassH/2))
    glassPath.addLine(to: CGPoint(x: glassW/2, y: glassH/2))
    glassPath.addLine(to: CGPoint(x: bottomW/2, y: -glassH/2))
    glassPath.addArc(center: CGPoint(x: 0, y: -glassH/2), radius: bottomW/2, startAngle: 0, endAngle: .pi, clockwise: false)
    glassPath.closeSubpath()

    // Glass Shadow
    g.saveGState()
    g.setShadow(offset: CGSize(width: -p * 0.02, height: -p * 0.03), blur: p * 0.08, color: color(0, 0, 0, 0.7))
    g.addPath(glassPath)
    g.fillPath()
    g.restoreGState()

    // 4. Liquid (Amber Beer)
    let liquidH = glassH * 0.85
    let liquidPath = CGMutablePath()
    let liquidTopW = bottomW + (glassW - bottomW) * (liquidH / glassH)
    liquidPath.move(to: CGPoint(x: -bottomW/2, y: -glassH/2))
    liquidPath.addLine(to: CGPoint(x: -liquidTopW/2, y: -glassH/2 + liquidH))
    liquidPath.addLine(to: CGPoint(x: liquidTopW/2, y: -glassH/2 + liquidH))
    liquidPath.addLine(to: CGPoint(x: bottomW/2, y: -glassH/2))
    liquidPath.addArc(center: CGPoint(x: 0, y: -glassH/2), radius: bottomW/2, startAngle: 0, endAngle: .pi, clockwise: false)
    liquidPath.closeSubpath()

    g.saveGState()
    g.addPath(liquidPath)
    g.clip()
    let beerGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1.0, 0.8, 0.2), // Light Golden Top
        color(0.8, 0.4, 0.0), // Deep Amber
        color(0.4, 0.1, 0.0), // Dark Bottom
    ] as CFArray, locations: [0.0, 0.7, 1.0])!
    g.drawLinearGradient(beerGrad, start: CGPoint(x: 0, y: -glassH/2 + liquidH), end: CGPoint(x: 0, y: -glassH/2), options: [])
    
    // Internal Refractions
    g.setBlendMode(.screen)
    let refractGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1.0, 0.9, 0.5, 0.4),
        color(0, 0, 0, 0)
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawRadialGradient(refractGrad, startCenter: CGPoint(x: -liquidTopW * 0.2, y: 0), startRadius: 0, endCenter: CGPoint(x: -liquidTopW * 0.2, y: 0), endRadius: liquidTopW * 0.4, options: [])
    g.restoreGState()

    // 5. Foam Head
    let foamH = glassH * 0.15
    let foamRect = CGRect(x: -glassW/2 - p * 0.01, y: -glassH/2 + liquidH - foamH * 0.2, width: glassW + p * 0.02, height: foamH)
    let foamPath = CGPath(roundedRect: foamRect, cornerWidth: foamH * 0.5, cornerHeight: foamH * 0.5, transform: nil)
    
    g.saveGState()
    g.setShadow(offset: .zero, blur: p * 0.02, color: color(1, 1, 1, 0.3))
    let foamGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1.0, 1.0, 1.0),
        color(0.92, 0.92, 0.88),
    ] as CFArray, locations: [0.0, 1.0])!
    g.addPath(foamPath)
    g.clip()
    g.drawLinearGradient(foamGrad, start: CGPoint(x: 0, y: foamRect.maxY), end: CGPoint(x: 0, y: foamRect.minY), options: [])
    
    // Bubbles in foam
    g.setFillColor(color(1, 1, 1, 0.4))
    for _ in 0..<20 {
        let bx = CGFloat.random(in: foamRect.minX...foamRect.maxX)
        let by = CGFloat.random(in: foamRect.minY...foamRect.maxY)
        let br = CGFloat.random(in: p * 0.005...p * 0.015)
        g.fillEllipse(in: CGRect(x: bx, y: by, width: br, height: br))
    }
    g.restoreGState()

    // 6. Glass Material (Overlays)
    g.saveGState()
    g.setLineWidth(p * 0.008)
    g.setStrokeColor(color(1, 1, 1, 0.4))
    g.addPath(glassPath)
    g.strokePath()
    
    // Highlights
    g.saveGState()
    g.setBlendMode(.screen)
    let highlightPath = CGMutablePath()
    highlightPath.move(to: CGPoint(x: -glassW * 0.4, y: -glassH * 0.4))
    highlightPath.addLine(to: CGPoint(x: -glassW * 0.45, y: glassH * 0.4))
    g.setLineWidth(p * 0.02)
    g.setLineCap(.round)
    g.setStrokeColor(color(1, 1, 1, 0.5))
    g.addPath(highlightPath)
    g.strokePath()
    
    // Bottom weight reflection
    let bottomRect = CGRect(x: -bottomW/2 + p * 0.02, y: -glassH/2 + p * 0.01, width: bottomW - p * 0.04, height: p * 0.04)
    g.setFillColor(color(1, 1, 1, 0.2))
    g.fillEllipse(in: bottomRect)
    g.restoreGState()
    g.restoreGState()

    // 7. Hop Leaf Detail (Subtle, near the glass)
    g.saveGState()
    g.translateBy(x: p * 0.35, y: p * 0.35)
    g.rotate(by: 0.5)
    let leafPath = CGMutablePath()
    leafPath.move(to: .zero)
    leafPath.addCurve(to: CGPoint(x: p * 0.08, y: p * 0.04), control1: CGPoint(x: p * 0.02, y: p * 0.06), control2: CGPoint(x: p * 0.06, y: p * 0.06))
    leafPath.addCurve(to: .zero, control1: CGPoint(x: p * 0.06, y: -p * 0.02), control2: CGPoint(x: p * 0.02, y: -p * 0.02))
    g.setFillColor(color(0.1, 0.4, 0.1, 0.4))
    g.addPath(leafPath)
    g.fillPath()
    g.restoreGState()

    // 8. Green Badge (Bottom-Right)
    let bSz = p * 0.22
    let bX = p * 0.70
    let bY = p * 0.08
    let bRect = CGRect(x: bX, y: bY, width: bSz, height: bSz)
    let bCenter = CGPoint(x: bX + bSz/2, y: bY + bSz/2)

    g.saveGState()
    g.setShadow(offset: CGSize(width: 0, height: p * 0.01), blur: p * 0.03, color: color(0, 0, 0, 0.5))
    let bGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.2, 0.8, 0.3),
        color(0.1, 0.5, 0.2),
    ] as CFArray, locations: [0.0, 1.0])!
    g.addEllipse(in: bRect)
    g.clip()
    g.drawLinearGradient(bGrad, start: CGPoint(x: bX, y: bY + bSz), end: CGPoint(x: bX, y: bY), options: [])
    g.restoreGState()

    // Sync Arrows
    let arrowR = bSz * 0.25
    g.saveGState()
    g.setStrokeColor(color(1, 1, 1, 0.95))
    g.setLineWidth(p * 0.025)
    g.setLineCap(.round)
    for startAngle: CGFloat in [0.2, 1.2] {
        let arc = CGMutablePath()
        arc.addArc(center: bCenter, radius: arrowR, startAngle: .pi * startAngle, endAngle: .pi * (startAngle + 0.6), clockwise: false)
        g.addPath(arc)
        g.strokePath()
        
        let tipAngle = .pi * (startAngle + 0.6)
        let tipPt = CGPoint(x: bCenter.x + arrowR * cos(tipAngle), y: bCenter.y + arrowR * sin(tipAngle))
        let tipDir = tipAngle + .pi / 2
        let tL = p * 0.03
        let tip = CGMutablePath()
        tip.move(to: tipPt)
        tip.addLine(to: CGPoint(x: tipPt.x + tL * cos(tipDir + 2.4), y: tipPt.y + tL * sin(tipDir + 2.4)))
        tip.addLine(to: CGPoint(x: tipPt.x + tL * cos(tipDir - 2.4), y: tipPt.y + tL * sin(tipDir - 2.4)))
        tip.closeSubpath()
        g.setFillColor(color(1, 1, 1, 0.95))
        g.addPath(tip)
        g.fillPath()
    }
    g.restoreGState()

    NSGraphicsContext.current = nil
    let png = rep.representation(using: .png, properties: [:])!
    try! png.write(to: URL(fileURLWithPath: output))
}

generateIcon()
