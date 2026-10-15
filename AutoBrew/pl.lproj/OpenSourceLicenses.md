<!-- doc-id: OPEN_SOURCE_NOTICES | lang: en | area: shared | version: 1.0.0 | valid-from: 2026-08-31 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/OPEN_SOURCE_NOTICES.en.md | adaptations: direct distribution (§ 1.1), copyleft statement (§ 2.2), example entry replaced by the actual inventory (§ 3), licence list reduced to the licences in use (§ 4), EULA link replaced by in-app document name | translated-from: en -->
# INFORMACJE O OPROGRAMOWANIU OPEN SOURCE

## Wskazanie autorstwa oprogramowania open source podmiotów trzecich

**Aplikacja:** AutoBrew

**Ostatnia aktualizacja:** 15 października 2026 r.

**Wydawca:**
DigitalFreedom
Marka DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Kontakt: hello@digitalfreedom.co.za
Strona internetowa: https://digitalfreedom.co.za

---

## 1. WPROWADZENIE

Niniejszy dokument wymienia komponenty oprogramowania open source wykorzystywane w AutoBrew („Oprogramowanie”). Każdy komponent podlega własnym warunkom licencyjnym, które przytoczono lub do których odesłano poniżej.

Niniejsza informacja jest przekazywana w celu spełnienia wymogów mających zastosowanie licencji open source dotyczących wskazania autorstwa i zamieszczania informacji oraz zgodnie z naszą EULA (w AutoBrew w Ustawienia → Informacje prawne → EULA).

### 1.1 Zasięg globalny

AutoBrew jest dystrybuowany bezpośrednio przez Wydawcę — jako poświadczony notarialnie przez Apple (notarized) plik do pobrania z GitHub Releases oraz za pośrednictwem repozytorium Homebrew tap `marcelrgberger/homebrew-tap` — i można go pobrać w każdym kraju, z którego te kanały są dostępne. Niniejsze informacje o oprogramowaniu open source obowiązują globalnie — informacje o prawach autorskich, teksty licencji i wymogi dotyczące wskazania autorstwa są przedstawione zgodnie z wymogami licencji każdego komponentu oraz w sposób umożliwiający ich egzekwowanie na gruncie unijnego prawa autorskiego (przyjętego jako standard bazowy) i prawa autorskiego każdej innej jurysdykcji, w której Oprogramowanie jest rozpowszechniane.

---

## 2. POSTANOWIENIA OGÓLNE

### 2.1 Hierarchia licencji

Jeżeli Oprogramowanie zawiera komponenty open source:

- komponenty te podlegają warunkom licencji open source
- nasza EULA nie ma pierwszeństwa przed prawami przyznanymi przez licencje open source ani ich nie ogranicza
- w razie sprzeczności między EULA a licencją open source pierwszeństwo w odniesieniu do danego komponentu ma licencja open source

### 2.2 Dostępność kodu źródłowego

Sam AutoBrew jest oprogramowaniem open source; jego pełny kod źródłowy jest opublikowany pod adresem https://github.com/marcelrgberger/auto-brew. Kod źródłowy dołączonych komponentów jest dostępny pod adresami repozytoriów wymienionymi w sekcji 3.

AutoBrew nie zawiera obecnie żadnego komponentu udostępnianego na licencji typu copyleft (np. GPL, LGPL, MPL). Gdyby taki komponent został dodany, w odniesieniu do niego obowiązuje, co następuje:

- kod źródłowy jest dostępny na żądanie pod adresem: hello@digitalfreedom.co.za
- żądania są realizowane w ciągu 30 dni
- oferty udostępnienia kodu źródłowego pozostają ważne przez 3 lata od daty ostatniego rozpowszechnienia lub przez inny okres wymagany przez mającą zastosowanie licencję

### 2.3 Obowiązki Użytkownika

Jeżeli Użytkownik dalej rozpowszechnia Oprogramowanie lub jego komponenty, odpowiada za przestrzeganie mających zastosowanie warunków licencji open source, w tym za:

- zachowanie informacji o prawach autorskich i tekstów licencji
- udostępnienie kodu źródłowego, jeżeli jest to wymagane
- zachowanie informacji o autorstwie

---

## 3. KOMPONENTY OPEN SOURCE

Dla każdego komponentu open source podano następujące informacje: nazwę komponentu, wersję, licencję, właściciela (właścicieli) praw autorskich oraz repozytorium.

### 3.1 AutoBrew

```
Component: AutoBrew
Version: 2.5.4
License: MIT
Copyright: Copyright (c) 2026 DigitalFreedom Global LLC
Repository: https://github.com/marcelrgberger/auto-brew
```

**Licencja MIT** (w brzmieniu opublikowanym w repozytorium AutoBrew):

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

### 3.2 Sparkle (dołączony)

```
Component: Sparkle
Version: 2.9.0
License: MIT; bundled external code under BSD-2-Clause, MIT and zlib (see below)
Copyright: Andy Matuschak, Elgato Systems GmbH, Kornel Lesiński, Mayur Pawashe,
           C.W. Betts, Petroules Corporation, Big Nerd Ranch (full notice below)
Repository: https://github.com/sparkle-project/Sparkle
Used for: AutoBrew's own software updates (EdDSA-signed appcast on GitHub)
```

Sparkle zawiera kod z bsdiff 4.3 (BSD-2-Clause), sais-lite (MIT), przenośnej implementacji Ed25519 autorstwa Orsona Petersa (zlib) oraz `SUSignatureVerifier.m` autorstwa Marka Hamlina (BSD-2-Clause). Pełny plik licencji Sparkle, wraz z tymi licencjami zewnętrznymi, przytoczono w brzmieniu oryginalnym:

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

Ten sam plik licencji jest dostarczany wewnątrz aplikacji w `AutoBrew.app/Contents/Frameworks/Sparkle.framework/Resources/LICENSE`.

### 3.3 Homebrew (zależność środowiska uruchomieniowego, niedołączona)

```
Component: Homebrew
License: BSD-2-Clause
Copyright: Copyright (c) 2009-present, Homebrew contributors
Repository: https://github.com/Homebrew/brew
```

Homebrew nie stanowi części pakietu aplikacji AutoBrew. AutoBrew uruchamia polecenie `brew` instalacji Homebrew na komputerze Mac Użytkownika, a jeżeli Homebrew nie jest zainstalowany i Użytkownik o to poprosi, uruchamia oficjalny skrypt instalacyjny Homebrew. Homebrew jest instalowany i licencjonowany odrębnie na podstawie własnej licencji BSD-2-Clause.

### 3.4 Frameworki systemowe Apple

AutoBrew jest łączony z frameworkami, które stanowią część systemu macOS i są wykorzystywane na warunkach SDK Apple, a nie na licencji open source: SwiftUI, AppKit, Foundation, Observation, UserNotifications, ServiceManagement, IOKit, CryptoKit, UniformTypeIdentifiers, WidgetKit, AppIntents oraz ujednolicony system rejestrowania (`os`). Wymieniono je wyłącznie dla kompletności.

---

## 4. TEKSTY POWSZECHNIE STOSOWANYCH LICENCJI

### 4.1 Licencja MIT

Zob. pełne teksty w sekcjach 3.1 i 3.2; dalsze informacje: https://opensource.org/licenses/MIT

### 4.2 Licencja BSD 2-Clause („Simplified”)

Komponenty udostępniane na licencji BSD 2-Clause podlegają warunkom dostępnym pod adresem:
https://opensource.org/licenses/BSD-2-Clause

### 4.3 Licencja zlib

Komponenty udostępniane na licencji zlib podlegają warunkom dostępnym pod adresem:
https://opensource.org/licenses/Zlib

---

## 5. KWESTIE PRAWNE W POSZCZEGÓLNYCH JURYSDYKCJACH

### 5.1 Unia Europejska

- Przestrzeganie licencji open source jest wymagane na gruncie unijnego prawa autorskiego (dyrektywa 2001/29/WE)
- Unijna dyrektywa w sprawie programów komputerowych (2009/24/WE) zezwala na dekompilację w celu zapewnienia interoperacyjności
- Akt o cyberodporności (rozporządzenie (UE) 2024/2847) może nakładać dodatkowe obowiązki w odniesieniu do oprogramowania komercyjnego zawierającego komponenty open source

### 5.2 Niemcy

- Prawa autorskie do oprogramowania reguluje UrhG (Urheberrechtsgesetz)
- Licencje open source są co do zasady wykonalne na gruncie niemieckiego prawa umów
- Sądy niemieckie egzekwowały licencję GPL i inne licencje open source (np. LG München I, LG Hamburg)

### 5.3 Stany Zjednoczone

- Prawa autorskie do oprogramowania reguluje Copyright Act (17 U.S.C.)
- Licencje open source są wykonalne jako licencje prawnoautorskie
- Mogą mieć zastosowanie przepisy DMCA dotyczące wyłączenia odpowiedzialności (safe harbor)

### 5.4 Zjednoczone Królestwo

- Prawa autorskie do oprogramowania reguluje Copyright, Designs and Patents Act 1988
- Licencje open source są wykonalne na gruncie angielskiego prawa umów i prawa autorskiego

### 5.5 Japonia

- Prawa autorskie do oprogramowania reguluje ustawa o prawie autorskim (著作権法)
- Licencje open source są uznawane i wykonalne

### 5.6 Inne jurysdykcje

- Wykonalność licencji open source może się różnić w zależności od jurysdykcji
- Prawa i obowiązki licencjobiorców reguluje lokalne prawo autorskie

---

## 6. AKTUALIZACJE

Niniejszy dokument jest aktualizowany w przypadku dodania nowych komponentów open source lub aktualizacji istniejących komponentów. Data „Ostatnia aktualizacja” podana na początku odzwierciedla najnowszą wersję.

Brakujące lub nieprawidłowe wskazania autorstwa można zgłaszać pod adresem https://github.com/marcelrgberger/auto-brew/issues lub na adres hello@digitalfreedom.co.za.

---

## 7. KONTAKT

W sprawie pytań dotyczących komponentów open source, przestrzegania licencji lub żądań udostępnienia kodu źródłowego:

DigitalFreedom
Marka DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
E-mail: hello@digitalfreedom.co.za
Strona internetowa: https://digitalfreedom.co.za

---

(c) 2025-2026 DigitalFreedom Global LLC. Wszelkie prawa zastrzeżone.

*Uwaga: powyższa informacja o prawach autorskich dotyczy wyłącznie niniejszego dokumentu, a nie wymienionych w nim komponentów open source, które podlegają swoim odpowiednim licencjom.*
