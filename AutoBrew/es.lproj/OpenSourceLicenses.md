<!-- doc-id: OPEN_SOURCE_NOTICES | lang: en | area: shared | version: 1.0.0 | valid-from: 2026-08-31 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/OPEN_SOURCE_NOTICES.en.md | adaptations: direct distribution (§ 1.1), copyleft statement (§ 2.2), example entry replaced by the actual inventory (§ 3), licence list reduced to the licences in use (§ 4), EULA link replaced by in-app document name | translated-from: en -->
# AVISOS DE CÓDIGO ABIERTO

## Atribución de software de código abierto de terceros

**Aplicación:** AutoBrew

**Última actualización:** 15 de octubre de 2026

**Editor:**
DigitalFreedom
Una marca de DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contacto: hello@digitalfreedom.co.za
Sitio web: https://digitalfreedom.co.za

---

## 1. INTRODUCCIÓN

Este documento enumera los componentes de software de código abierto utilizados en AutoBrew ("el Software"). Cada componente está sujeto a sus propias condiciones de licencia, que se reproducen o se citan a continuación.

Este aviso se facilita en cumplimiento de los requisitos de atribución y aviso de las licencias de código abierto aplicables y de conformidad con nuestro CLUF (en AutoBrew, en Ajustes → Legal → CLUF).

### 1.1 Ámbito global

AutoBrew se distribuye directamente por el Editor —como descarga notarizada desde GitHub Releases y a través del tap de Homebrew `marcelrgberger/homebrew-tap`— y puede descargarse en todos los países desde los que se pueda acceder a estos canales. Estos avisos de código abierto se aplican a nivel mundial: los avisos de derechos de autor, los textos de licencia y los requisitos de atribución se presentan tal como lo exige la licencia de cada componente y en la forma exigible conforme al derecho de autor de la UE (tomado como referencia) y al derecho de autor de cualquier otra jurisdicción en la que se distribuya el Software.

---

## 2. CONDICIONES GENERALES

### 2.1 Jerarquía de licencias

Cuando el Software incluye componentes de código abierto:

- Las condiciones de la licencia de código abierto rigen dichos componentes
- Nuestro CLUF no prevalece sobre los derechos concedidos por las licencias de código abierto ni los restringe
- En caso de conflicto entre el CLUF y una licencia de código abierto, prevalece la licencia de código abierto para el componente afectado

### 2.2 Disponibilidad del código fuente

AutoBrew es en sí mismo de código abierto; su código fuente completo está publicado en https://github.com/marcelrgberger/auto-brew. El código fuente de los componentes incluidos está disponible en las URL de los repositorios indicadas en la Sección 3.

Actualmente, AutoBrew no contiene ningún componente con licencia copyleft (por ejemplo, GPL, LGPL, MPL). Si se añadiera alguno, se aplicará lo siguiente:

- El código fuente está disponible previa solicitud en: hello@digitalfreedom.co.za
- Las solicitudes se atenderán en un plazo de 30 días
- Las ofertas de código fuente siguen siendo válidas durante 3 años desde la última fecha de distribución, o durante el plazo que exija la licencia aplicable

### 2.3 Sus obligaciones

Si redistribuye el Software o componentes del mismo, usted es responsable de cumplir las condiciones de las licencias de código abierto aplicables, entre ellas:

- Conservar los avisos de derechos de autor y los textos de licencia
- Facilitar el código fuente cuando se exija
- Mantener los avisos de atribución

---

## 3. COMPONENTES DE CÓDIGO ABIERTO

Para cada componente de código abierto se facilita la siguiente información: nombre del componente, versión, licencia, titular o titulares de los derechos de autor y repositorio.

### 3.1 AutoBrew

```
Component: AutoBrew
Version: 2.5.3
License: MIT
Copyright: Copyright (c) 2026 DigitalFreedom Global LLC
Repository: https://github.com/marcelrgberger/auto-brew
```

**Licencia MIT** (tal como se publica en el repositorio de AutoBrew):

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

### 3.2 Sparkle (incluido)

```
Component: Sparkle
Version: 2.9.0
License: MIT; bundled external code under BSD-2-Clause, MIT and zlib (see below)
Copyright: Andy Matuschak, Elgato Systems GmbH, Kornel Lesiński, Mayur Pawashe,
           C.W. Betts, Petroules Corporation, Big Nerd Ranch (full notice below)
Repository: https://github.com/sparkle-project/Sparkle
Used for: AutoBrew's own software updates (EdDSA-signed appcast on GitHub)
```

Sparkle incluye código de bsdiff 4.3 (BSD-2-Clause), sais-lite (MIT), la implementación portable de Ed25519 de Orson Peters (zlib) y `SUSignatureVerifier.m` de Mark Hamlin (BSD-2-Clause). El archivo de licencia completo de Sparkle, incluidas estas licencias externas, se reproduce literalmente:

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

El mismo archivo de licencia se incluye dentro de la aplicación en `AutoBrew.app/Contents/Frameworks/Sparkle.framework/Resources/LICENSE`.

### 3.3 Homebrew (dependencia en tiempo de ejecución, no incluida)

```
Component: Homebrew
License: BSD-2-Clause
Copyright: Copyright (c) 2009-present, Homebrew contributors
Repository: https://github.com/Homebrew/brew
```

Homebrew no forma parte del paquete de la aplicación AutoBrew. AutoBrew ejecuta el comando `brew` de la instalación de Homebrew de su Mac y, si Homebrew no está instalado y usted lo solicita, ejecuta el script oficial de instalación de Homebrew. Homebrew se instala y se licencia por separado bajo su propia licencia BSD-2-Clause.

### 3.4 Frameworks del sistema de Apple

AutoBrew enlaza frameworks que forman parte de macOS y que se utilizan conforme a las condiciones del SDK de Apple, no bajo una licencia de código abierto: SwiftUI, AppKit, Foundation, Observation, UserNotifications, ServiceManagement, IOKit, CryptoKit, UniformTypeIdentifiers, WidgetKit, AppIntents y el sistema de registro unificado (`os`). Se enumeran únicamente a efectos de exhaustividad.

---

## 4. TEXTOS DE LICENCIA HABITUALES

### 4.1 Licencia MIT

Véanse los textos completos en las Secciones 3.1 y 3.2; más información: https://opensource.org/licenses/MIT

### 4.2 Licencia BSD de 2 cláusulas ("Simplified")

Los componentes con licencia BSD de 2 cláusulas están sujetos a las condiciones disponibles en:
https://opensource.org/licenses/BSD-2-Clause

### 4.3 Licencia zlib

Los componentes con licencia zlib están sujetos a las condiciones disponibles en:
https://opensource.org/licenses/Zlib

---

## 5. CONSIDERACIONES JURÍDICAS POR JURISDICCIÓN

### 5.1 Unión Europea

- El cumplimiento de las licencias de código abierto es obligatorio conforme al derecho de autor de la UE (Directiva 2001/29/CE)
- La Directiva de la UE sobre programas de ordenador (2009/24/CE) permite la descompilación para la interoperabilidad
- El Reglamento de Ciberresiliencia (Reglamento (UE) 2024/2847) puede imponer obligaciones adicionales al software comercial que incorpore componentes de código abierto

### 5.2 Alemania

- La UrhG (Urheberrechtsgesetz) rige los derechos de autor sobre el software
- Las licencias de código abierto son, por lo general, exigibles conforme al derecho contractual alemán
- Los tribunales alemanes han hecho cumplir la GPL y otras licencias de código abierto (p. ej., LG München I, LG Hamburg)

### 5.3 Estados Unidos

- La Copyright Act (17 U.S.C.) rige los derechos de autor sobre el software
- Las licencias de código abierto son exigibles como licencias de derechos de autor
- Pueden aplicarse las disposiciones de puerto seguro (safe harbor) de la DMCA

### 5.4 Reino Unido

- La Copyright, Designs and Patents Act 1988 rige los derechos de autor sobre el software
- Las licencias de código abierto son exigibles conforme al derecho contractual y de derechos de autor inglés

### 5.5 Japón

- La Ley de Derechos de Autor (著作権法) rige los derechos de autor sobre el software
- Las licencias de código abierto están reconocidas y son exigibles

### 5.6 Otras jurisdicciones

- La exigibilidad de las licencias de código abierto puede variar según la jurisdicción
- La legislación local sobre derechos de autor rige los derechos y obligaciones de los licenciatarios

---

## 6. ACTUALIZACIONES

Este documento se actualiza cuando se añaden nuevos componentes de código abierto o se actualizan los existentes. La fecha de "Última actualización" que figura al principio refleja la revisión más reciente.

Las atribuciones que falten o sean incorrectas pueden comunicarse en https://github.com/marcelrgberger/auto-brew/issues o a hello@digitalfreedom.co.za.

---

## 7. CONTACTO

Para preguntas sobre componentes de código abierto, cumplimiento de licencias o solicitudes de código fuente:

DigitalFreedom
Una marca de DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Correo electrónico: hello@digitalfreedom.co.za
Sitio web: https://digitalfreedom.co.za

---

(c) 2025-2026 DigitalFreedom Global LLC. Todos los derechos reservados.

*Nota: el aviso de derechos de autor anterior se aplica a este documento en sí, no a los componentes de código abierto aquí enumerados, que están sujetos a sus respectivas licencias.*
