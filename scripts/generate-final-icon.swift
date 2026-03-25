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

    // 1. Background (macOS squircle shape)
    let corner: CGFloat = p * 0.225
    let bgPath = CGPath(roundedRect: CGRect(x: 0, y: 0, width: p, height: p), cornerWidth: corner, cornerHeight: corner, transform: nil)

    g.saveGState()
    g.addPath(bgPath)
    g.clip()
    
    // Deep rich gradient: warm amber/copper to dark espresso brown
    let bgGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.85, 0.45, 0.20), // Amber/Copper
        color(0.15, 0.08, 0.05), // Dark Espresso
    ] as CFArray, locations: [0.0, 0.8])!
    g.drawLinearGradient(bgGrad, start: CGPoint(x: p * 0.2, y: p * 0.9), end: CGPoint(x: p * 0.8, y: p * 0.1), options: [])
    g.restoreGState()

    // Subtle inner glow/shadow for the background edges
    g.saveGState()
    g.addPath(bgPath)
    g.setLineWidth(p * 0.02)
    g.setStrokeColor(color(1, 1, 1, 0.15))
    g.strokePath()
    g.restoreGState()

    // 2. Mug (3D-rendered perspective)
    // Mug is viewed slightly from above.
    let mugW = p * 0.42
    let mugH = p * 0.46
    let mugX = (p - mugW) * 0.45 // Slightly off-center to make room for handle
    let mugY = p * 0.22
    
    let mugRect = CGRect(x: mugX, y: mugY, width: mugW, height: mugH)
    
    // Mug body (cylindrical shape with rounded bottom)
    let mugBodyPath = CGMutablePath()
    let mugR = p * 0.06
    mugBodyPath.move(to: CGPoint(x: mugX, y: mugY + mugH))
    mugBodyPath.addLine(to: CGPoint(x: mugX + mugW, y: mugY + mugH))
    mugBodyPath.addLine(to: CGPoint(x: mugX + mugW, y: mugY + mugR))
    mugBodyPath.addArc(center: CGPoint(x: mugX + mugW - mugR, y: mugY + mugR), radius: mugR, startAngle: 0, endAngle: -.pi/2, clockwise: true)
    mugBodyPath.addLine(to: CGPoint(x: mugX + mugR, y: mugY))
    mugBodyPath.addArc(center: CGPoint(x: mugX + mugR, y: mugY + mugR), radius: mugR, startAngle: -.pi/2, endAngle: .pi, clockwise: true)
    mugBodyPath.closeSubpath()

    // Mug Shadow (Ambient Occlusion & Soft Shadow)
    g.saveGState()
    g.setShadow(offset: CGSize(width: 0, height: -p * 0.04), blur: p * 0.08, color: color(0, 0, 0, 0.5))
    g.addPath(mugBodyPath)
    g.setFillColor(color(0, 0, 0, 0.2))
    g.fillPath()
    g.restoreGState()

    // Mug Body Fill (Matte white ceramic with subtle depth)
    g.saveGState()
    g.addPath(mugBodyPath)
    g.clip()
    let mugGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.98, 0.98, 0.98), // High highlight
        color(0.92, 0.92, 0.92), // Base
        color(0.85, 0.85, 0.85), // Soft shadow on the right/bottom
    ] as CFArray, locations: [0.0, 0.4, 1.0])!
    g.drawLinearGradient(mugGrad, start: CGPoint(x: mugX, y: mugY + mugH), end: CGPoint(x: mugX + mugW, y: mugY), options: [])
    g.restoreGState()

    // Mug Rim (Ellipse for 3D perspective)
    let rimH = p * 0.08
    let rimRect = CGRect(x: mugX, y: mugY + mugH - rimH/2, width: mugW, height: rimH)
    let rimPath = CGPath(ellipseIn: rimRect, transform: nil)
    
    g.saveGState()
    g.addPath(rimPath)
    g.setFillColor(color(1, 1, 1, 1.0))
    g.fillPath()
    // Rim highlight
    g.setLineWidth(p * 0.005)
    g.setStrokeColor(color(0.9, 0.9, 0.9, 0.5))
    g.strokePath()
    g.restoreGState()

    // Inner Mug (Depth)
    let innerRimRect = rimRect.insetBy(dx: p * 0.02, dy: p * 0.005)
    let innerRimPath = CGPath(ellipseIn: innerRimRect, transform: nil)
    g.saveGState()
    g.addPath(innerRimPath)
    g.clip()
    let innerGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.1, 0.05, 0.02), // Dark coffee
        color(0.25, 0.12, 0.05), // Medium coffee
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawRadialGradient(innerGrad, startCenter: CGPoint(x: innerRimRect.midX, y: innerRimRect.midY), startRadius: 0, endCenter: CGPoint(x: innerRimRect.midX, y: innerRimRect.midY), endRadius: innerRimRect.width/2, options: [])
    g.restoreGState()

    // Handle (3D look)
    let handlePath = CGMutablePath()
    let hX = mugX + mugW - p * 0.02
    let hY = mugY + mugH * 0.5
    let hW = p * 0.18
    let hH = p * 0.28
    let handleRect = CGRect(x: hX, y: hY - hH/2, width: hW, height: hH)
    handlePath.addEllipse(in: handleRect)
    
    g.saveGState()
    g.setShadow(offset: CGSize(width: p * 0.01, height: -p * 0.01), blur: p * 0.03, color: color(0, 0, 0, 0.3))
    g.setLineWidth(p * 0.05)
    g.setStrokeColor(color(0.95, 0.95, 0.95, 1.0))
    // We only want the outer part of the ellipse as the handle
    g.addPath(handlePath)
    g.clip(to: CGRect(x: mugX + mugW, y: 0, width: p, height: p))
    g.addPath(handlePath)
    g.strokePath()
    g.restoreGState()

    // 3. Steam Wisps
    g.saveGState()
    g.setStrokeColor(color(1, 1, 1, 0.3))
    g.setLineWidth(p * 0.02)
    g.setLineCap(.round)
    g.setShadow(offset: .zero, blur: p * 0.02, color: color(1, 1, 1, 0.5))
    
    let steamBase = mugY + mugH + p * 0.02
    for i in 0..<3 {
        let sx = mugX + mugW * (0.3 + CGFloat(i) * 0.2)
        let sw = p * 0.04
        let sh = p * 0.15
        let sPath = CGMutablePath()
        sPath.move(to: CGPoint(x: sx, y: steamBase))
        sPath.addCurve(to: CGPoint(x: sx + (i % 2 == 0 ? sw : -sw), y: steamBase + sh),
                       control1: CGPoint(x: sx - sw, y: steamBase + sh * 0.4),
                       control2: CGPoint(x: sx + sw, y: steamBase + sh * 0.6))
        g.addPath(sPath)
        g.strokePath()
    }
    g.restoreGState()

    // 4. Green Badge (Bottom-Right)
    let bSz = p * 0.28
    let bX = p * 0.64
    let bY = p * 0.08
    let bRect = CGRect(x: bX, y: bY, width: bSz, height: bSz)
    let bCenter = CGPoint(x: bX + bSz/2, y: bY + bSz/2)

    // Badge Shadow
    g.saveGState()
    g.setShadow(offset: CGSize(width: 0, height: p * 0.01), blur: p * 0.04, color: color(0, 0, 0, 0.4))
    
    // Badge Body (Glossy Green)
    g.setFillColor(color(0.15, 0.70, 0.30))
    g.fillEllipse(in: bRect)
    g.restoreGState()
    
    g.saveGState()
    g.addEllipse(in: bRect)
    g.clip()
    let bGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(0.25, 0.85, 0.40), // Top
        color(0.10, 0.50, 0.20), // Bottom
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawLinearGradient(bGrad, start: CGPoint(x: bX, y: bY + bSz), end: CGPoint(x: bX, y: bY), options: [])
    
    // Glass highlight on badge
    let highlightRect = bRect.insetBy(dx: bSz * 0.1, dy: bSz * 0.1).offsetBy(dx: 0, dy: bSz * 0.2)
    let highlightGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        color(1, 1, 1, 0.4),
        color(1, 1, 1, 0.0),
    ] as CFArray, locations: [0.0, 1.0])!
    g.drawEllipse(in: highlightRect, gradient: highlightGrad)
    
    g.restoreGState()

    // Circular Refresh Arrows in Badge
    let arrowR = bSz * 0.28
    g.saveGState()
    g.setStrokeColor(color(1, 1, 1, 0.95))
    g.setLineWidth(p * 0.025)
    g.setLineCap(.round)
    
    for startAngle: CGFloat in [0.25, 1.25] {
        let arc = CGMutablePath()
        arc.addArc(center: bCenter, radius: arrowR, startAngle: .pi * startAngle, endAngle: .pi * (startAngle + 0.55), clockwise: false)
        g.addPath(arc)
        g.strokePath()
        
        // Arrow tip
        let tipAngle = .pi * (startAngle + 0.55)
        let tipPt = CGPoint(x: bCenter.x + arrowR * cos(tipAngle), y: bCenter.y + arrowR * sin(tipAngle))
        let tipDir = tipAngle + .pi / 2
        let tL = p * 0.035
        let tip = CGMutablePath()
        tip.move(to: tipPt)
        tip.addLine(to: CGPoint(x: tipPt.x + tL * cos(tipDir + 2.3), y: tipPt.y + tL * sin(tipDir + 2.3)))
        tip.addLine(to: CGPoint(x: tipPt.x + tL * cos(tipDir - 2.3), y: tipPt.y + tL * sin(tipDir - 2.3)))
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

extension CGContext {
    func drawEllipse(in rect: CGRect, gradient: CGGradient) {
        saveGState()
        addEllipse(in: rect)
        clip()
        drawLinearGradient(gradient, start: CGPoint(x: rect.midX, y: rect.maxY), end: CGPoint(x: rect.midX, y: rect.minY), options: [])
        restoreGState()
    }
}

generateIcon()
print("Success: \(output)")
