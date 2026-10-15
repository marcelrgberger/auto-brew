<!-- doc-id: OPEN_SOURCE_NOTICES | lang: en | area: shared | version: 1.0.0 | valid-from: 2026-08-31 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/OPEN_SOURCE_NOTICES.en.md | adaptations: direct distribution (§ 1.1), copyleft statement (§ 2.2), example entry replaced by the actual inventory (§ 3), licence list reduced to the licences in use (§ 4), EULA link replaced by in-app document name | translated-from: en -->
# OPEN-SOURCE-HINWEISE

## Namensnennung für Open-Source-Software Dritter

**Anwendung:** AutoBrew

**Stand:** 15. Oktober 2026

**Herausgeber:**
DigitalFreedom
Eine Marke der DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Kontakt: hello@digitalfreedom.co.za
Website: https://digitalfreedom.co.za

---

## 1. EINLEITUNG

Dieses Dokument listet die in AutoBrew („die Software“) verwendeten Open-Source-Softwarekomponenten auf. Jede Komponente unterliegt ihren eigenen Lizenzbedingungen, die nachstehend wiedergegeben oder in Bezug genommen werden.

Dieser Hinweis wird in Erfüllung der Namensnennungs- und Hinweispflichten der anwendbaren Open-Source-Lizenzen und im Einklang mit unserer EULA (in AutoBrew unter Einstellungen → Rechtliches → EULA) bereitgestellt.

### 1.1 Weltweiter Geltungsbereich

AutoBrew wird vom Herausgeber direkt vertrieben — als notarisierter Download über GitHub Releases und über den Homebrew-Tap `marcelrgberger/homebrew-tap` — und kann in jedem Land heruntergeladen werden, von dem aus diese Kanäle erreichbar sind. Diese Open-Source-Hinweise gelten weltweit — Urheberrechtsvermerke, Lizenztexte und Namensnennungspflichten werden so dargestellt, wie es die Lizenz der jeweiligen Komponente verlangt und wie es nach dem EU-Urheberrecht (als Grundstandard) und dem Urheberrecht jeder anderen Rechtsordnung, in der die Software vertrieben wird, durchsetzbar ist.

---

## 2. ALLGEMEINE BESTIMMUNGEN

### 2.1 Rangfolge der Lizenzen

Soweit die Software Open-Source-Komponenten enthält, gilt:

- Die Open-Source-Lizenzbedingungen regeln diese Komponenten
- Unsere EULA setzt Rechte, die durch Open-Source-Lizenzen eingeräumt werden, weder außer Kraft noch schränkt sie sie ein
- Bei einem Widerspruch zwischen der EULA und einer Open-Source-Lizenz hat die Open-Source-Lizenz für die betroffene Komponente Vorrang

### 2.2 Verfügbarkeit des Quellcodes

AutoBrew selbst ist Open Source; sein vollständiger Quellcode ist unter https://github.com/marcelrgberger/auto-brew veröffentlicht. Der Quellcode der mitgelieferten Komponenten ist unter den in Abschnitt 3 genannten Repository-URLs verfügbar.

AutoBrew enthält derzeit keine Komponente, die unter einer Copyleft-Lizenz (z. B. GPL, LGPL, MPL) lizenziert ist. Sollte eine solche hinzukommen, gilt für sie Folgendes:

- Der Quellcode ist auf Anfrage erhältlich unter: hello@digitalfreedom.co.za
- Anfragen werden innerhalb von 30 Tagen erfüllt
- Angebote zur Bereitstellung des Quellcodes bleiben für 3 Jahre ab dem letzten Vertriebsdatum gültig oder so lange, wie es die anwendbare Lizenz anderweitig verlangt

### 2.3 Ihre Pflichten

Wenn Sie die Software oder Komponenten davon weiterverbreiten, sind Sie für die Einhaltung der anwendbaren Open-Source-Lizenzbedingungen verantwortlich, einschließlich:

- der Beibehaltung von Urheberrechtsvermerken und Lizenztexten
- der Bereitstellung des Quellcodes, soweit erforderlich
- der Beibehaltung von Namensnennungshinweisen

---

## 3. OPEN-SOURCE-KOMPONENTEN

Für jede Open-Source-Komponente werden folgende Angaben gemacht: Name der Komponente, Version, Lizenz, Urheberrechtsinhaber und Repository.

### 3.1 AutoBrew

```
Component: AutoBrew
Version: 2.5.4
License: MIT
Copyright: Copyright (c) 2026 DigitalFreedom Global LLC
Repository: https://github.com/marcelrgberger/auto-brew
```

**MIT-Lizenz** (wie im AutoBrew-Repository veröffentlicht, im englischen Original):

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

### 3.2 Sparkle (mitgeliefert)

```
Component: Sparkle
Version: 2.9.0
License: MIT; bundled external code under BSD-2-Clause, MIT and zlib (see below)
Copyright: Andy Matuschak, Elgato Systems GmbH, Kornel Lesiński, Mayur Pawashe,
           C.W. Betts, Petroules Corporation, Big Nerd Ranch (full notice below)
Repository: https://github.com/sparkle-project/Sparkle
Used for: AutoBrew's own software updates (EdDSA-signed appcast on GitHub)
```

Sparkle enthält Code aus bsdiff 4.3 (BSD-2-Clause), sais-lite (MIT), der portablen Ed25519-Implementierung von Orson Peters (zlib) und `SUSignatureVerifier.m` von Mark Hamlin (BSD-2-Clause). Die vollständige Lizenzdatei von Sparkle einschließlich dieser externen Lizenzen wird wörtlich im englischen Original wiedergegeben:

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

Dieselbe Lizenzdatei wird innerhalb der Anwendung unter `AutoBrew.app/Contents/Frameworks/Sparkle.framework/Resources/LICENSE` ausgeliefert.

### 3.3 Homebrew (Laufzeitabhängigkeit, nicht mitgeliefert)

```
Component: Homebrew
License: BSD-2-Clause
Copyright: Copyright (c) 2009-present, Homebrew contributors
Repository: https://github.com/Homebrew/brew
```

Homebrew ist nicht Bestandteil des AutoBrew-Anwendungspakets. AutoBrew führt den Befehl `brew` der Homebrew-Installation auf Ihrem Mac aus und führt, wenn Homebrew fehlt und Sie dies wünschen, das offizielle Homebrew-Installationsskript aus. Homebrew wird separat installiert und unter seiner eigenen BSD-2-Clause-Lizenz lizenziert.

### 3.4 Apple-Systemframeworks

AutoBrew bindet Frameworks ein, die Bestandteil von macOS sind und nach Apples SDK-Bedingungen genutzt werden, nicht unter einer Open-Source-Lizenz: SwiftUI, AppKit, Foundation, Observation, UserNotifications, ServiceManagement, IOKit, CryptoKit, UniformTypeIdentifiers, WidgetKit, AppIntents und das einheitliche Protokollsystem (`os`). Sie werden nur der Vollständigkeit halber aufgeführt.

---

## 4. GEBRÄUCHLICHE LIZENZTEXTE

### 4.1 MIT-Lizenz

Siehe die vollständigen Texte in den Abschnitten 3.1 und 3.2; weitere Informationen: https://opensource.org/licenses/MIT

### 4.2 BSD-2-Clause-Lizenz („Simplified“)

Komponenten, die unter der BSD-2-Clause-Lizenz lizenziert sind, unterliegen den unter folgender Adresse abrufbaren Bedingungen:
https://opensource.org/licenses/BSD-2-Clause

### 4.3 zlib-Lizenz

Komponenten, die unter der zlib-Lizenz lizenziert sind, unterliegen den unter folgender Adresse abrufbaren Bedingungen:
https://opensource.org/licenses/Zlib

---

## 5. RECHTLICHE ASPEKTE NACH RECHTSORDNUNG

### 5.1 Europäische Union

- Die Einhaltung von Open-Source-Lizenzen ist nach EU-Urheberrecht erforderlich (Richtlinie 2001/29/EG)
- Die EU-Software-Richtlinie (2009/24/EG) erlaubt die Dekompilierung zur Herstellung der Interoperabilität
- Der Cyber Resilience Act (Verordnung (EU) 2024/2847) kann kommerzieller Software, die Open-Source-Komponenten enthält, zusätzliche Pflichten auferlegen

### 5.2 Deutschland

- Das UrhG (Urheberrechtsgesetz) regelt das Urheberrecht an Software
- Open-Source-Lizenzen sind nach deutschem Vertragsrecht grundsätzlich durchsetzbar
- Deutsche Gerichte haben die GPL und andere Open-Source-Lizenzen durchgesetzt (z. B. LG München I, LG Hamburg)

### 5.3 Vereinigte Staaten

- Der Copyright Act (17 U.S.C.) regelt das Urheberrecht an Software
- Open-Source-Lizenzen sind als urheberrechtliche Lizenzen durchsetzbar
- Die Safe-Harbor-Bestimmungen des DMCA können anwendbar sein

### 5.4 Vereinigtes Königreich

- Der Copyright, Designs and Patents Act 1988 regelt das Urheberrecht an Software
- Open-Source-Lizenzen sind nach englischem Vertrags- und Urheberrecht durchsetzbar

### 5.5 Japan

- Das Urheberrechtsgesetz (著作権法) regelt das Urheberrecht an Software
- Open-Source-Lizenzen sind anerkannt und durchsetzbar

### 5.6 Sonstige Rechtsordnungen

- Die Durchsetzbarkeit von Open-Source-Lizenzen kann je nach Rechtsordnung unterschiedlich sein
- Das örtliche Urheberrecht regelt die Rechte und Pflichten der Lizenznehmer

---

## 6. AKTUALISIERUNGEN

Dieses Dokument wird aktualisiert, wenn neue Open-Source-Komponenten hinzukommen oder bestehende Komponenten aktualisiert werden. Das Datum „Stand“ am Anfang gibt den Stand der letzten Überarbeitung wieder.

Fehlende oder fehlerhafte Namensnennungen können unter https://github.com/marcelrgberger/auto-brew/issues oder an hello@digitalfreedom.co.za gemeldet werden.

---

## 7. KONTAKT

Bei Fragen zu Open-Source-Komponenten, zur Lizenzeinhaltung oder zu Anfragen nach Quellcode:

DigitalFreedom
Eine Marke der DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
E-Mail: hello@digitalfreedom.co.za
Website: https://digitalfreedom.co.za

---

(c) 2025-2026 DigitalFreedom Global LLC. Alle Rechte vorbehalten.

*Hinweis: Der vorstehende Urheberrechtsvermerk gilt für dieses Dokument selbst, nicht für die hierin aufgeführten Open-Source-Komponenten, die ihren jeweiligen Lizenzen unterliegen.*
