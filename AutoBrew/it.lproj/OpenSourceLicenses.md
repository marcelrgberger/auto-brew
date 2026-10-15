<!-- doc-id: OPEN_SOURCE_NOTICES | lang: en | area: shared | version: 1.0.0 | valid-from: 2026-08-31 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/OPEN_SOURCE_NOTICES.en.md | adaptations: direct distribution (§ 1.1), copyleft statement (§ 2.2), example entry replaced by the actual inventory (§ 3), licence list reduced to the licences in use (§ 4), EULA link replaced by in-app document name | translated-from: en -->
# INFORMATIVE SULLE LICENZE OPEN SOURCE

## Attribuzione del software open source di terzi

**Applicazione:** AutoBrew

**Ultimo aggiornamento:** 15 ottobre 2026

**Editore:**
DigitalFreedom
Un marchio di DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contatto: hello@digitalfreedom.co.za
Sito web: https://digitalfreedom.co.za

---

## 1. INTRODUZIONE

Il presente documento elenca i componenti software open source utilizzati in AutoBrew (il "Software"). Ciascun componente è soggetto alle proprie condizioni di licenza, riprodotte o richiamate di seguito.

La presente informativa è fornita in adempimento degli obblighi di attribuzione e di informativa previsti dalle licenze open source applicabili e conformemente alla nostra EULA (in AutoBrew in Impostazioni → Note legali → EULA).

### 1.1 Ambito di applicazione globale

AutoBrew è distribuita direttamente dall'Editore, come download notarizzato da GitHub Releases e tramite il tap Homebrew `marcelrgberger/homebrew-tap`, e può essere scaricata in ogni Paese dal quale tali canali sono raggiungibili. Le presenti informative open source si applicano a livello globale: le note sul diritto d'autore, i testi di licenza e gli obblighi di attribuzione sono riportati come richiesto dalla licenza di ciascun componente e come azionabili ai sensi del diritto d'autore dell'UE (assunto come base di riferimento) e del diritto d'autore di ogni altra giurisdizione in cui il Software è distribuito.

---

## 2. CONDIZIONI GENERALI

### 2.1 Gerarchia delle licenze

Laddove il Software includa componenti open source:

- Le condizioni delle licenze open source disciplinano tali componenti
- La nostra EULA non prevale sui diritti conferiti dalle licenze open source né li limita
- In caso di contrasto tra l'EULA e una licenza open source, prevale la licenza open source per il componente interessato

### 2.2 Disponibilità del codice sorgente

AutoBrew stessa è open source; il suo codice sorgente completo è pubblicato all'indirizzo https://github.com/marcelrgberger/auto-brew. Il codice sorgente dei componenti inclusi è disponibile agli indirizzi dei repository elencati nella Sezione 3.

AutoBrew attualmente non contiene alcun componente concesso in licenza secondo una licenza copyleft (ad es. GPL, LGPL, MPL). Qualora ne venisse aggiunto uno, a esso si applica quanto segue:

- Il codice sorgente è disponibile su richiesta all'indirizzo: hello@digitalfreedom.co.za
- Le richieste saranno evase entro 30 giorni
- Le offerte di codice sorgente restano valide per 3 anni dalla data dell'ultima distribuzione, o per il diverso periodo richiesto dalla licenza applicabile

### 2.3 I vostri obblighi

Se ridistribuite il Software o suoi componenti, siete responsabili del rispetto delle condizioni delle licenze open source applicabili, tra cui:

- Conservare le note sul diritto d'autore e i testi di licenza
- Fornire il codice sorgente ove richiesto
- Mantenere le note di attribuzione

---

## 3. COMPONENTI OPEN SOURCE

Per ciascun componente open source sono fornite le seguenti informazioni: nome del componente, versione, licenza, titolare/i del diritto d'autore e repository.

### 3.1 AutoBrew

```
Component: AutoBrew
Version: 2.5.3
License: MIT
Copyright: Copyright (c) 2026 DigitalFreedom Global LLC
Repository: https://github.com/marcelrgberger/auto-brew
```

**MIT License** (come pubblicata nel repository di AutoBrew):

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

### 3.2 Sparkle (incluso)

```
Component: Sparkle
Version: 2.9.0
License: MIT; bundled external code under BSD-2-Clause, MIT and zlib (see below)
Copyright: Andy Matuschak, Elgato Systems GmbH, Kornel Lesiński, Mayur Pawashe,
           C.W. Betts, Petroules Corporation, Big Nerd Ranch (full notice below)
Repository: https://github.com/sparkle-project/Sparkle
Used for: AutoBrew's own software updates (EdDSA-signed appcast on GitHub)
```

Sparkle include codice di bsdiff 4.3 (BSD-2-Clause), sais-lite (MIT), l'implementazione portabile di Ed25519 di Orson Peters (zlib) e `SUSignatureVerifier.m` di Mark Hamlin (BSD-2-Clause). Il file di licenza completo di Sparkle, comprese tali licenze esterne, è riprodotto testualmente:

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

Lo stesso file di licenza è incluso nell'applicazione in `AutoBrew.app/Contents/Frameworks/Sparkle.framework/Resources/LICENSE`.

### 3.3 Homebrew (dipendenza di runtime, non inclusa)

```
Component: Homebrew
License: BSD-2-Clause
Copyright: Copyright (c) 2009-present, Homebrew contributors
Repository: https://github.com/Homebrew/brew
```

Homebrew non fa parte del bundle dell'applicazione AutoBrew. AutoBrew esegue il comando `brew` dell'installazione di Homebrew sul vostro Mac e, se Homebrew non è presente e lo richiedete, esegue lo script di installazione ufficiale di Homebrew. Homebrew è installato e concesso in licenza separatamente secondo la propria licenza BSD-2-Clause.

### 3.4 Framework di sistema Apple

AutoBrew si collega a framework che fanno parte di macOS e sono utilizzati in base alle condizioni dell'SDK di Apple, non secondo una licenza open source: SwiftUI, AppKit, Foundation, Observation, UserNotifications, ServiceManagement, IOKit, CryptoKit, UniformTypeIdentifiers, WidgetKit, AppIntents e il sistema di registrazione unificato (`os`). Sono elencati solo per completezza.

---

## 4. TESTI DI LICENZA RICORRENTI

### 4.1 MIT License

Si vedano i testi completi nelle Sezioni 3.1 e 3.2; ulteriori informazioni: https://opensource.org/licenses/MIT

### 4.2 BSD 2-Clause License ("Simplified")

I componenti concessi in licenza secondo la BSD 2-Clause License sono soggetti alle condizioni disponibili all'indirizzo:
https://opensource.org/licenses/BSD-2-Clause

### 4.3 zlib License

I componenti concessi in licenza secondo la zlib License sono soggetti alle condizioni disponibili all'indirizzo:
https://opensource.org/licenses/Zlib

---

## 5. ASPETTI GIURIDICI PER GIURISDIZIONE

### 5.1 Unione europea

- Il rispetto delle licenze open source è richiesto dal diritto d'autore dell'UE (Direttiva 2001/29/CE)
- La Direttiva UE sui programmi per elaboratore (2009/24/CE) consente la decompilazione ai fini dell'interoperabilità
- Il Cyber Resilience Act (Regolamento (UE) 2024/2847) può imporre obblighi aggiuntivi al software commerciale che incorpora componenti open source

### 5.2 Germania

- La UrhG (Urheberrechtsgesetz) disciplina il diritto d'autore sul software
- Le licenze open source sono di norma azionabili ai sensi del diritto contrattuale tedesco
- I tribunali tedeschi hanno dato esecuzione alla GPL e ad altre licenze open source (ad es. LG München I, LG Hamburg)

### 5.3 Stati Uniti

- Il Copyright Act (17 U.S.C.) disciplina il diritto d'autore sul software
- Le licenze open source sono azionabili in quanto licenze di diritto d'autore
- Possono applicarsi le disposizioni di safe harbor del DMCA

### 5.4 Regno Unito

- Il Copyright, Designs and Patents Act 1988 disciplina il diritto d'autore sul software
- Le licenze open source sono azionabili ai sensi del diritto contrattuale e del diritto d'autore inglesi

### 5.5 Giappone

- Il Copyright Act (著作権法) disciplina il diritto d'autore sul software
- Le licenze open source sono riconosciute e azionabili

### 5.6 Altre giurisdizioni

- L'azionabilità delle licenze open source può variare a seconda della giurisdizione
- Il diritto d'autore locale disciplina i diritti e gli obblighi dei licenziatari

---

## 6. AGGIORNAMENTI

Il presente documento viene aggiornato quando vengono aggiunti nuovi componenti open source o aggiornati quelli esistenti. La data di "Ultimo aggiornamento" indicata in alto corrisponde all'ultima revisione.

Attribuzioni mancanti o errate possono essere segnalate all'indirizzo https://github.com/marcelrgberger/auto-brew/issues oppure a hello@digitalfreedom.co.za.

---

## 7. CONTATTI

Per domande sui componenti open source, sul rispetto delle licenze o per richieste di codice sorgente:

DigitalFreedom
Un marchio di DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
E-mail: hello@digitalfreedom.co.za
Sito web: https://digitalfreedom.co.za

---

(c) 2025-2026 DigitalFreedom Global LLC. Tutti i diritti riservati.

*Nota: la nota sul diritto d'autore di cui sopra si riferisce al presente documento in quanto tale, non ai componenti open source qui elencati, che sono soggetti alle rispettive licenze.*
