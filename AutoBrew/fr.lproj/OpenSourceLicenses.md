<!-- doc-id: OPEN_SOURCE_NOTICES | lang: en | area: shared | version: 1.0.0 | valid-from: 2026-08-31 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/OPEN_SOURCE_NOTICES.en.md | adaptations: direct distribution (§ 1.1), copyleft statement (§ 2.2), example entry replaced by the actual inventory (§ 3), licence list reduced to the licences in use (§ 4), EULA link replaced by in-app document name | translated-from: en -->
# MENTIONS RELATIVES AUX LOGICIELS OPEN SOURCE

## Attribution des logiciels open source de tiers

**Application :** AutoBrew

**Dernière mise à jour :** 15 octobre 2026

**Éditeur :**
DigitalFreedom
Une marque de DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contact : hello@digitalfreedom.co.za
Site web : https://digitalfreedom.co.za

---

## 1. INTRODUCTION

Le présent document énumère les composants logiciels open source utilisés dans AutoBrew (« le Logiciel »). Chaque composant est soumis à ses propres conditions de licence, qui sont reproduites ou référencées ci-dessous.

Le présent avis est fourni conformément aux exigences d'attribution et de mention des licences open source applicables et conformément à notre CLUF (dans AutoBrew sous Réglages → Mentions légales → CLUF).

### 1.1 Portée mondiale

AutoBrew est distribué directement par l'Éditeur — sous forme de téléchargement notarié depuis GitHub Releases et via le tap Homebrew `marcelrgberger/homebrew-tap` — et peut être téléchargé dans tout pays depuis lequel ces canaux sont accessibles. Les présentes mentions open source s'appliquent dans le monde entier — les mentions de droit d'auteur, les textes de licence et les exigences d'attribution sont présentés conformément à la licence de chaque composant et tels qu'ils sont opposables en vertu du droit d'auteur de l'UE (retenu comme base de référence) et du droit d'auteur de toute autre juridiction dans laquelle le Logiciel est distribué.

---

## 2. CONDITIONS GÉNÉRALES

### 2.1 Hiérarchie des licences

Lorsque le Logiciel inclut des composants open source :

- Les conditions de la licence open source régissent ces composants
- Notre CLUF ne prévaut pas sur les droits conférés par les licences open source et ne les restreint pas
- En cas de conflit entre le CLUF et une licence open source, la licence open source prévaut pour le composant concerné

### 2.2 Disponibilité du code source

AutoBrew est lui-même open source ; son code source complet est publié à l'adresse https://github.com/marcelrgberger/auto-brew. Le code source des composants intégrés est disponible aux adresses des dépôts indiquées à la section 3.

AutoBrew ne contient actuellement aucun composant placé sous une licence copyleft (par exemple GPL, LGPL, MPL). Si un tel composant venait à être ajouté, les règles suivantes s'y appliqueraient :

- Le code source est disponible sur demande à l'adresse : hello@digitalfreedom.co.za
- Les demandes sont traitées dans un délai de 30 jours
- Les offres de code source restent valables 3 ans à compter de la date de la dernière distribution, ou pendant toute autre durée exigée par la licence applicable

### 2.3 Vos obligations

Si vous redistribuez le Logiciel ou certains de ses composants, il vous incombe de respecter les conditions des licences open source applicables, notamment :

- Conserver les mentions de droit d'auteur et les textes de licence
- Fournir le code source lorsque cela est exigé
- Maintenir les mentions d'attribution

---

## 3. COMPOSANTS OPEN SOURCE

Pour chaque composant open source, les informations suivantes sont fournies : nom du composant, version, licence, titulaire(s) du droit d'auteur et dépôt.

### 3.1 AutoBrew

```
Component: AutoBrew
Version: 2.5.3
License: MIT
Copyright: Copyright (c) 2026 DigitalFreedom Global LLC
Repository: https://github.com/marcelrgberger/auto-brew
```

**Licence MIT** (telle que publiée dans le dépôt d'AutoBrew, reproduite en anglais dans sa version originale) :

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

### 3.2 Sparkle (intégré)

```
Component: Sparkle
Version: 2.9.0
License: MIT; bundled external code under BSD-2-Clause, MIT and zlib (see below)
Copyright: Andy Matuschak, Elgato Systems GmbH, Kornel Lesiński, Mayur Pawashe,
           C.W. Betts, Petroules Corporation, Big Nerd Ranch (full notice below)
Repository: https://github.com/sparkle-project/Sparkle
Used for: AutoBrew's own software updates (EdDSA-signed appcast on GitHub)
```

Sparkle intègre du code provenant de bsdiff 4.3 (BSD-2-Clause), de sais-lite (MIT), de l'implémentation portable d'Ed25519 d'Orson Peters (zlib) et de `SUSignatureVerifier.m` de Mark Hamlin (BSD-2-Clause). Le fichier de licence complet de Sparkle, y compris ces licences externes, est reproduit ci-dessous dans sa version originale anglaise :

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

Le même fichier de licence est fourni dans l'application à l'emplacement `AutoBrew.app/Contents/Frameworks/Sparkle.framework/Resources/LICENSE`.

### 3.3 Homebrew (dépendance d'exécution, non intégrée)

```
Component: Homebrew
License: BSD-2-Clause
Copyright: Copyright (c) 2009-present, Homebrew contributors
Repository: https://github.com/Homebrew/brew
```

Homebrew ne fait pas partie du paquet de l'application AutoBrew. AutoBrew exécute la commande `brew` de l'installation Homebrew présente sur votre Mac et, si Homebrew est absent et que vous le demandez, exécute le script d'installation officiel de Homebrew. Homebrew est installé séparément et placé sous sa propre licence BSD-2-Clause.

### 3.4 Frameworks système d'Apple

AutoBrew est lié à des frameworks qui font partie de macOS et sont utilisés selon les conditions du SDK d'Apple, et non sous une licence open source : SwiftUI, AppKit, Foundation, Observation, UserNotifications, ServiceManagement, IOKit, CryptoKit, UniformTypeIdentifiers, WidgetKit, AppIntents et le système de journalisation unifié (`os`). Ils ne sont mentionnés qu'à titre d'exhaustivité.

---

## 4. TEXTES DE LICENCE COURANTS

### 4.1 Licence MIT

Voir les textes complets aux sections 3.1 et 3.2 ; informations complémentaires : https://opensource.org/licenses/MIT

### 4.2 Licence BSD à 2 clauses (« simplifiée »)

Les composants placés sous la licence BSD à 2 clauses sont soumis aux conditions disponibles à l'adresse :
https://opensource.org/licenses/BSD-2-Clause

### 4.3 Licence zlib

Les composants placés sous la licence zlib sont soumis aux conditions disponibles à l'adresse :
https://opensource.org/licenses/Zlib

---

## 5. CONSIDÉRATIONS JURIDIQUES PAR JURIDICTION

### 5.1 Union européenne

- Le respect des licences open source est exigé par le droit d'auteur de l'UE (directive 2001/29/CE)
- La directive de l'UE sur les programmes d'ordinateur (2009/24/CE) autorise la décompilation à des fins d'interopérabilité
- Le Cyber Resilience Act (règlement (UE) 2024/2847) peut imposer des obligations supplémentaires aux logiciels commerciaux intégrant des composants open source

### 5.2 Allemagne

- L'UrhG (Urheberrechtsgesetz) régit le droit d'auteur sur les logiciels
- Les licences open source sont en règle générale opposables en vertu du droit allemand des contrats
- Les juridictions allemandes ont fait appliquer la GPL et d'autres licences open source (par exemple LG München I, LG Hamburg)

### 5.3 États-Unis

- Le Copyright Act (17 U.S.C.) régit le droit d'auteur sur les logiciels
- Les licences open source sont opposables en tant que licences de droit d'auteur
- Les dispositions d'exonération (safe harbor) du DMCA peuvent s'appliquer

### 5.4 Royaume-Uni

- Le Copyright, Designs and Patents Act 1988 régit le droit d'auteur sur les logiciels
- Les licences open source sont opposables en vertu du droit anglais des contrats et du droit d'auteur

### 5.5 Japon

- La loi sur le droit d'auteur (著作権法) régit le droit d'auteur sur les logiciels
- Les licences open source sont reconnues et opposables

### 5.6 Autres juridictions

- L'opposabilité des licences open source peut varier selon les juridictions
- Le droit d'auteur local régit les droits et obligations des licenciés

---

## 6. MISES À JOUR

Le présent document est mis à jour lorsque de nouveaux composants open source sont ajoutés ou que des composants existants sont mis à jour. La date de « Dernière mise à jour » figurant en tête reflète la révision la plus récente.

Les attributions manquantes ou incorrectes peuvent être signalées à l'adresse https://github.com/marcelrgberger/auto-brew/issues ou à hello@digitalfreedom.co.za.

---

## 7. CONTACT

Pour toute question relative aux composants open source, au respect des licences ou aux demandes de code source :

DigitalFreedom
Une marque de DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
E-mail : hello@digitalfreedom.co.za
Site web : https://digitalfreedom.co.za

---

(c) 2025-2026 DigitalFreedom Global LLC. Tous droits réservés.

*Remarque : la mention de droit d'auteur ci-dessus s'applique au présent document lui-même, et non aux composants open source qui y sont énumérés, lesquels sont soumis à leurs licences respectives.*
