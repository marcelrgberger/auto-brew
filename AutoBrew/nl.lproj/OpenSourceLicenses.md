<!-- doc-id: OPEN_SOURCE_NOTICES | lang: en | area: shared | version: 1.0.0 | valid-from: 2026-08-31 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/OPEN_SOURCE_NOTICES.en.md | adaptations: direct distribution (§ 1.1), copyleft statement (§ 2.2), example entry replaced by the actual inventory (§ 3), licence list reduced to the licences in use (§ 4), EULA link replaced by in-app document name | translated-from: en -->
# OPEN-SOURCEVERMELDINGEN

## Vermelding van open-sourcesoftware van derden

**Applicatie:** AutoBrew

**Laatst bijgewerkt:** 15 oktober 2026

**Uitgever:**
DigitalFreedom
Een merk van DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contact: hello@digitalfreedom.co.za
Website: https://digitalfreedom.co.za

---

## 1. INLEIDING

Dit document vermeldt de open-sourcesoftwarecomponenten die in AutoBrew ("de Software") worden gebruikt. Op elke component zijn eigen licentievoorwaarden van toepassing, die hieronder worden weergegeven of waarnaar hieronder wordt verwezen.

Deze vermelding wordt verstrekt ter naleving van de vermeldings- en kennisgevingsvereisten van de toepasselijke open-sourcelicenties en in overeenstemming met onze EULA (in AutoBrew onder Instellingen → Juridisch → EULA).

### 1.1 Wereldwijde reikwijdte

AutoBrew wordt rechtstreeks door de Uitgever verspreid — als genotariseerde download via GitHub Releases en via de Homebrew-tap `marcelrgberger/homebrew-tap` — en kan worden gedownload in elk land van waaruit deze kanalen bereikbaar zijn. Deze open-sourcevermeldingen gelden wereldwijd — auteursrechtvermeldingen, licentieteksten en vermeldingsvereisten worden weergegeven zoals vereist door de licentie van elke component en zoals afdwingbaar op grond van het EU-auteursrecht (als basis genomen) en het auteursrecht van elk ander rechtsgebied waarin de Software wordt verspreid.

---

## 2. ALGEMENE VOORWAARDEN

### 2.1 Rangorde van licenties

Voor zover de Software open-sourcecomponenten bevat:

- Beheersen de open-sourcelicentievoorwaarden die componenten
- Heeft onze EULA geen voorrang boven rechten die door open-sourcelicenties worden verleend en beperkt zij die rechten niet
- Prevaleert bij strijdigheid tussen de EULA en een open-sourcelicentie de open-sourcelicentie voor de betreffende component

### 2.2 Beschikbaarheid van de broncode

AutoBrew is zelf open source; de volledige broncode is gepubliceerd op https://github.com/marcelrgberger/auto-brew. De broncode van de meegeleverde componenten is beschikbaar via de in artikel 3 vermelde repository-URL's.

AutoBrew bevat momenteel geen component die onder een copyleftlicentie (bijv. GPL, LGPL, MPL) is gelicentieerd. Mocht er een worden toegevoegd, dan geldt daarvoor het volgende:

- De broncode is op verzoek verkrijgbaar via: hello@digitalfreedom.co.za
- Verzoeken worden binnen 30 dagen ingewilligd
- Aanbiedingen van broncode blijven geldig gedurende 3 jaar na de laatste distributiedatum, of zoals anderszins vereist door de toepasselijke licentie

### 2.3 Uw verplichtingen

Indien u de Software of componenten daarvan herdistribueert, bent u verantwoordelijk voor de naleving van de toepasselijke open-sourcelicentievoorwaarden, waaronder:

- Het behouden van auteursrechtvermeldingen en licentieteksten
- Het verstrekken van de broncode waar vereist
- Het in stand houden van vermeldingen

---

## 3. OPEN-SOURCECOMPONENTEN

Voor elke open-sourcecomponent wordt de volgende informatie verstrekt: naam van de component, versie, licentie, auteursrechthebbende(n) en repository.

### 3.1 AutoBrew

```
Component: AutoBrew
Version: 2.5.4
License: MIT
Copyright: Copyright (c) 2026 DigitalFreedom Global LLC
Repository: https://github.com/marcelrgberger/auto-brew
```

**MIT License** (zoals gepubliceerd in de AutoBrew-repository):

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

### 3.2 Sparkle (meegeleverd)

```
Component: Sparkle
Version: 2.9.0
License: MIT; bundled external code under BSD-2-Clause, MIT and zlib (see below)
Copyright: Andy Matuschak, Elgato Systems GmbH, Kornel Lesiński, Mayur Pawashe,
           C.W. Betts, Petroules Corporation, Big Nerd Ranch (full notice below)
Repository: https://github.com/sparkle-project/Sparkle
Used for: AutoBrew's own software updates (EdDSA-signed appcast on GitHub)
```

Sparkle bevat code uit bsdiff 4.3 (BSD-2-Clause), sais-lite (MIT), de draagbare Ed25519-implementatie van Orson Peters (zlib) en `SUSignatureVerifier.m` van Mark Hamlin (BSD-2-Clause). Het volledige licentiebestand van Sparkle, inclusief deze externe licenties, wordt hieronder letterlijk weergegeven:

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

Hetzelfde licentiebestand wordt binnen de applicatie meegeleverd op `AutoBrew.app/Contents/Frameworks/Sparkle.framework/Resources/LICENSE`.

### 3.3 Homebrew (runtime-afhankelijkheid, niet meegeleverd)

```
Component: Homebrew
License: BSD-2-Clause
Copyright: Copyright (c) 2009-present, Homebrew contributors
Repository: https://github.com/Homebrew/brew
```

Homebrew maakt geen deel uit van de AutoBrew-applicatiebundel. AutoBrew voert de opdracht `brew` uit van de Homebrew-installatie op uw Mac en voert, als Homebrew ontbreekt en u daarom verzoekt, het officiële Homebrew-installatiescript uit. Homebrew wordt afzonderlijk geïnstalleerd en is afzonderlijk gelicentieerd onder zijn eigen BSD-2-Clause-licentie.

### 3.4 Systeemframeworks van Apple

AutoBrew linkt tegen frameworks die deel uitmaken van macOS en worden gebruikt onder de SDK-voorwaarden van Apple, niet onder een open-sourcelicentie: SwiftUI, AppKit, Foundation, Observation, UserNotifications, ServiceManagement, IOKit, CryptoKit, UniformTypeIdentifiers, WidgetKit, AppIntents en het uniforme logsysteem (`os`). Zij worden uitsluitend volledigheidshalve vermeld.

---

## 4. GANGBARE LICENTIETEKSTEN

### 4.1 MIT License

Zie de volledige teksten in artikel 3.1 en 3.2; meer informatie: https://opensource.org/licenses/MIT

### 4.2 BSD 2-Clause License ("Simplified")

Op componenten die onder de BSD 2-Clause License zijn gelicentieerd, zijn de voorwaarden van toepassing die beschikbaar zijn op:
https://opensource.org/licenses/BSD-2-Clause

### 4.3 zlib License

Op componenten die onder de zlib License zijn gelicentieerd, zijn de voorwaarden van toepassing die beschikbaar zijn op:
https://opensource.org/licenses/Zlib

---

## 5. JURIDISCHE OVERWEGINGEN PER RECHTSGEBIED

### 5.1 Europese Unie

- Naleving van open-sourcelicenties is vereist op grond van het EU-auteursrecht (Richtlijn 2001/29/EG)
- De EU-softwarerichtlijn (2009/24/EG) staat decompilatie ten behoeve van interoperabiliteit toe
- De Cyberweerbaarheidsverordening (Verordening (EU) 2024/2847) kan aanvullende verplichtingen opleggen aan commerciële software waarin open-sourcecomponenten zijn verwerkt

### 5.2 Duitsland

- Het UrhG (Urheberrechtsgesetz) beheerst het auteursrecht op software
- Open-sourcelicenties zijn naar Duits contractenrecht in het algemeen afdwingbaar
- Duitse rechters hebben de GPL en andere open-sourcelicenties gehandhaafd (bijv. LG München I, LG Hamburg)

### 5.3 Verenigde Staten

- De Copyright Act (17 U.S.C.) beheerst het auteursrecht op software
- Open-sourcelicenties zijn afdwingbaar als auteursrechtlicenties
- De safe-harborbepalingen van de DMCA kunnen van toepassing zijn

### 5.4 Verenigd Koninkrijk

- De Copyright, Designs and Patents Act 1988 beheerst het auteursrecht op software
- Open-sourcelicenties zijn afdwingbaar naar Engels contracten- en auteursrecht

### 5.5 Japan

- De Copyright Act (著作権法) beheerst het auteursrecht op software
- Open-sourcelicenties worden erkend en zijn afdwingbaar

### 5.6 Overige rechtsgebieden

- De afdwingbaarheid van open-sourcelicenties kan per rechtsgebied verschillen
- Het lokale auteursrecht beheerst de rechten en verplichtingen van licentienemers

---

## 6. WIJZIGINGEN

Dit document wordt bijgewerkt wanneer nieuwe open-sourcecomponenten worden toegevoegd of bestaande componenten worden bijgewerkt. De datum "Laatst bijgewerkt" bovenaan geeft de meest recente herziening weer.

Ontbrekende of onjuiste vermeldingen kunnen worden gemeld via https://github.com/marcelrgberger/auto-brew/issues of aan hello@digitalfreedom.co.za.

---

## 7. CONTACT

Voor vragen over open-sourcecomponenten, naleving van licenties of verzoeken om broncode:

DigitalFreedom
Een merk van DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
E-mail: hello@digitalfreedom.co.za
Website: https://digitalfreedom.co.za

---

(c) 2025-2026 DigitalFreedom Global LLC. Alle rechten voorbehouden.

*Opmerking: de bovenstaande auteursrechtvermelding heeft betrekking op dit document zelf, niet op de hierin vermelde open-sourcecomponenten, waarop hun respectieve licenties van toepassing zijn.*
