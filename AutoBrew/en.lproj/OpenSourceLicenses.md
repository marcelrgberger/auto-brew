<!-- doc-id: OPEN_SOURCE_NOTICES | lang: en | area: shared | version: 1.0.0 | valid-from: 2026-08-31 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/OPEN_SOURCE_NOTICES.en.md | adaptations: direct distribution (§ 1.1), copyleft statement (§ 2.2), example entry replaced by the actual inventory (§ 3), licence list reduced to the licences in use (§ 4), EULA link replaced by in-app document name -->
# OPEN SOURCE NOTICES

## Third-Party Open Source Software Attribution

**Application:** AutoBrew

**Last Updated:** 15 October 2026

**Publisher:**
DigitalFreedom
A brand of DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contact: hello@digitalfreedom.co.za
Website: https://digitalfreedom.co.za

---

## 1. INTRODUCTION

This document lists the open-source software components used in AutoBrew ("the Software"). Each component is subject to its own license terms, which are reproduced or referenced below.

This notice is provided in compliance with the attribution and notice requirements of the applicable open-source licenses and in accordance with our EULA (in AutoBrew under Settings → Legal → EULA).

### 1.1 Global scope

AutoBrew is distributed directly by the Publisher — as a notarized download from GitHub Releases and through the Homebrew tap `marcelrgberger/homebrew-tap` — and can be downloaded in every country from which these channels can be reached. These open-source notices apply globally — copyright notices, license texts, and attribution requirements are presented as required by each component's licence and as enforceable under EU copyright law (taken as the baseline) and the copyright law of every other jurisdiction in which the Software is distributed.

---

## 2. GENERAL TERMS

### 2.1 License Hierarchy

Where the Software includes open-source components:

- The open-source license terms govern those components
- Our EULA does not override or restrict rights granted by open-source licenses
- In the event of conflict between the EULA and an open-source license, the open-source license prevails for the affected component

### 2.2 Source Code Availability

AutoBrew itself is open source; its complete source code is published at https://github.com/marcelrgberger/auto-brew. Source code of the bundled components is available at the repository URLs listed in Section 3.

AutoBrew currently contains no component licensed under a copyleft license (e.g., GPL, LGPL, MPL). Should one be added, the following applies to it:

- Source code is available upon request at: hello@digitalfreedom.co.za
- Requests will be fulfilled within 30 days
- Source code offers remain valid for 3 years from the last distribution date, or as otherwise required by the applicable license

### 2.3 Your Obligations

If you redistribute the Software or components thereof, you are responsible for compliance with the applicable open-source license terms, including:

- Retaining copyright notices and license texts
- Providing source code where required
- Maintaining attribution notices

---

## 3. OPEN SOURCE COMPONENTS

For each open-source component, the following information is provided: component name, version, license, copyright holder(s) and repository.

### 3.1 AutoBrew

```
Component: AutoBrew
Version: 2.5.3
License: MIT
Copyright: Copyright (c) 2026 DigitalFreedom Global LLC
Repository: https://github.com/marcelrgberger/auto-brew
```

**MIT License** (as published in the AutoBrew repository):

```
MIT License

Copyright (c) 2026 DigitalFreedom Global LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### 3.2 Sparkle (bundled)

```
Component: Sparkle
Version: 2.9.0
License: MIT; bundled external code under BSD-2-Clause, MIT and zlib (see below)
Copyright: Andy Matuschak, Elgato Systems GmbH, Kornel Lesiński, Mayur Pawashe,
           C.W. Betts, Petroules Corporation, Big Nerd Ranch (full notice below)
Repository: https://github.com/sparkle-project/Sparkle
Used for: AutoBrew's own software updates (EdDSA-signed appcast on GitHub)
```

Sparkle bundles code from bsdiff 4.3 (BSD-2-Clause), sais-lite (MIT), the portable Ed25519 implementation by Orson Peters (zlib) and `SUSignatureVerifier.m` by Mark Hamlin (BSD-2-Clause). The complete Sparkle licence file, including these external licences, is reproduced verbatim:

```
Copyright (c) 2006-2013 Andy Matuschak.
Copyright (c) 2009-2013 Elgato Systems GmbH.
Copyright (c) 2011-2014 Kornel Lesiński.
Copyright (c) 2015-2017 Mayur Pawashe.
Copyright (c) 2014 C.W. Betts.
Copyright (c) 2014 Petroules Corporation.
Copyright (c) 2014 Big Nerd Ranch.
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=================
EXTERNAL LICENSES
=================

bspatch.c and bsdiff.c, from bsdiff 4.3 <http://www.daemonology.net/bsdiff/>:

Copyright 2003-2005 Colin Percival
All rights reserved

Redistribution and use in source and binary forms, with or without
modification, are permitted providing that the following conditions 
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

--

sais.c and sais.h, from sais-lite (2010/08/07) <https://sites.google.com/site/yuta256/sais>:

The sais-lite copyright is as follows:

Copyright (c) 2008-2010 Yuta Mori All Rights Reserved.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

--

Portable C implementation of Ed25519, from https://github.com/orlp/ed25519

Copyright (c) 2015 Orson Peters <orsonpeters@gmail.com>

This software is provided 'as-is', without any express or implied warranty. In no event will the
authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial
applications, and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the
   original software. If you use this software in a product, an acknowledgment in the product
   documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as
   being the original software.

3. This notice may not be removed or altered from any source distribution.

--

SUSignatureVerifier.m:

Copyright (c) 2011 Mark Hamlin.

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted providing that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
```

The same licence file ships inside the application at `AutoBrew.app/Contents/Frameworks/Sparkle.framework/Resources/LICENSE`.

### 3.3 Homebrew (runtime dependency, not bundled)

```
Component: Homebrew
License: BSD-2-Clause
Copyright: Copyright (c) 2009-present, Homebrew contributors
Repository: https://github.com/Homebrew/brew
```

Homebrew is not part of the AutoBrew application bundle. AutoBrew runs the `brew` command of the Homebrew installation on your Mac and, if Homebrew is missing and you ask for it, runs the official Homebrew installation script. Homebrew is installed and licensed separately under its own BSD-2-Clause licence.

### 3.4 Apple system frameworks

AutoBrew links against frameworks that are part of macOS and are used under Apple's SDK terms, not under an open-source licence: SwiftUI, AppKit, Foundation, Observation, UserNotifications, ServiceManagement, IOKit, CryptoKit, UniformTypeIdentifiers, WidgetKit, AppIntents and the unified logging system (`os`). They are listed for completeness only.

---

## 4. COMMON LICENSE TEXTS

### 4.1 MIT License

See the full texts in Sections 3.1 and 3.2; further information: https://opensource.org/licenses/MIT

### 4.2 BSD 2-Clause License ("Simplified")

Components licensed under the BSD 2-Clause License are subject to the terms available at:
https://opensource.org/licenses/BSD-2-Clause

### 4.3 zlib License

Components licensed under the zlib License are subject to the terms available at:
https://opensource.org/licenses/Zlib

---

## 5. LEGAL CONSIDERATIONS BY JURISDICTION

### 5.1 European Union

- Open-source license compliance is required under EU copyright law (Directive 2001/29/EC)
- The EU Software Directive (2009/24/EC) permits decompilation for interoperability
- The Cyber Resilience Act (Regulation (EU) 2024/2847) may impose additional obligations on commercial software incorporating open-source components

### 5.2 Germany

- UrhG (Urheberrechtsgesetz) governs copyright in software
- Open-source licenses are generally enforceable under German contract law
- German courts have enforced GPL and other open-source licenses (e.g., LG München I, LG Hamburg)

### 5.3 United States

- Copyright Act (17 U.S.C.) governs software copyright
- Open-source licenses are enforceable as copyright licenses
- DMCA safe harbor provisions may apply

### 5.4 United Kingdom

- Copyright, Designs and Patents Act 1988 governs software copyright
- Open-source licenses are enforceable under English contract and copyright law

### 5.5 Japan

- Copyright Act (著作権法) governs software copyright
- Open-source licenses are recognized and enforceable

### 5.6 Other Jurisdictions

- Open-source license enforceability may vary by jurisdiction
- Local copyright law governs the rights and obligations of licensees

---

## 6. UPDATES

This document is updated when new open-source components are added or existing components are updated. The "Last Updated" date at the top reflects the latest revision.

Missing or incorrect attributions can be reported at https://github.com/marcelrgberger/auto-brew/issues or to hello@digitalfreedom.co.za.

---

## 7. CONTACT

For questions about open-source components, license compliance, or source code requests:

DigitalFreedom
A brand of DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Email: hello@digitalfreedom.co.za
Website: https://digitalfreedom.co.za

---

(c) 2025-2026 DigitalFreedom Global LLC. All rights reserved.

*Note: The copyright notice above applies to this document itself, not to the open-source components listed herein, which are subject to their respective licenses.*
