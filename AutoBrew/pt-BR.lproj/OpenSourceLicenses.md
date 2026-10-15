<!-- doc-id: OPEN_SOURCE_NOTICES | lang: en | area: shared | version: 1.0.0 | valid-from: 2026-08-31 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/OPEN_SOURCE_NOTICES.en.md | adaptations: direct distribution (§ 1.1), copyleft statement (§ 2.2), example entry replaced by the actual inventory (§ 3), licence list reduced to the licences in use (§ 4), EULA link replaced by in-app document name | translated-from: en -->
# AVISOS DE CÓDIGO ABERTO

## Atribuição de software de código aberto de terceiros

**Aplicativo:** AutoBrew

**Última atualização:** 15 de outubro de 2026

**Editor:**
DigitalFreedom
Uma marca da DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contato: hello@digitalfreedom.co.za
Site: https://digitalfreedom.co.za

---

## 1. INTRODUÇÃO

Este documento lista os componentes de software de código aberto utilizados no AutoBrew ("o Software"). Cada componente está sujeito aos seus próprios termos de licença, que são reproduzidos ou referenciados abaixo.

Este aviso é fornecido em cumprimento dos requisitos de atribuição e de aviso das licenças de código aberto aplicáveis e de acordo com o nosso EULA (no AutoBrew, em Configurações → Jurídico → EULA).

### 1.1 Âmbito global

O AutoBrew é distribuído diretamente pelo Editor — como download notarizado a partir do GitHub Releases e por meio do tap do Homebrew `marcelrgberger/homebrew-tap` — e pode ser baixado em todos os países a partir dos quais esses canais sejam acessíveis. Estes avisos de código aberto aplicam-se globalmente — avisos de direitos autorais, textos de licença e requisitos de atribuição são apresentados conforme exigido pela licença de cada componente e conforme exigível nos termos do direito autoral da UE (adotado como base) e do direito autoral de todas as demais jurisdições em que o Software é distribuído.

---

## 2. TERMOS GERAIS

### 2.1 Hierarquia de licenças

Quando o Software incluir componentes de código aberto:

- Os termos da licença de código aberto regem esses componentes
- Nosso EULA não se sobrepõe nem restringe os direitos concedidos pelas licenças de código aberto
- Em caso de conflito entre o EULA e uma licença de código aberto, prevalece a licença de código aberto quanto ao componente afetado

### 2.2 Disponibilidade do código-fonte

O próprio AutoBrew é de código aberto; seu código-fonte completo está publicado em https://github.com/marcelrgberger/auto-brew. O código-fonte dos componentes incluídos está disponível nos URLs de repositório indicados na Seção 3.

Atualmente, o AutoBrew não contém nenhum componente licenciado sob uma licença copyleft (por exemplo, GPL, LGPL, MPL). Caso algum venha a ser adicionado, aplica-se a ele o seguinte:

- O código-fonte está disponível mediante solicitação em: hello@digitalfreedom.co.za
- As solicitações serão atendidas em até 30 dias
- As ofertas de código-fonte permanecem válidas por 3 anos a partir da última data de distribuição, ou conforme exigido de outro modo pela licença aplicável

### 2.3 Suas obrigações

Se você redistribuir o Software ou componentes dele, será responsável por cumprir os termos das licenças de código aberto aplicáveis, incluindo:

- Manter os avisos de direitos autorais e os textos de licença
- Fornecer o código-fonte quando exigido
- Manter os avisos de atribuição

---

## 3. COMPONENTES DE CÓDIGO ABERTO

Para cada componente de código aberto, são fornecidas as seguintes informações: nome do componente, versão, licença, titular(es) dos direitos autorais e repositório.

### 3.1 AutoBrew

```
Component: AutoBrew
Version: 2.5.4
License: MIT
Copyright: Copyright (c) 2026 DigitalFreedom Global LLC
Repository: https://github.com/marcelrgberger/auto-brew
```

**MIT License** (conforme publicada no repositório do AutoBrew):

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

### 3.2 Sparkle (incluído)

```
Component: Sparkle
Version: 2.9.0
License: MIT; bundled external code under BSD-2-Clause, MIT and zlib (see below)
Copyright: Andy Matuschak, Elgato Systems GmbH, Kornel Lesiński, Mayur Pawashe,
           C.W. Betts, Petroules Corporation, Big Nerd Ranch (full notice below)
Repository: https://github.com/sparkle-project/Sparkle
Used for: AutoBrew's own software updates (EdDSA-signed appcast on GitHub)
```

O Sparkle inclui código do bsdiff 4.3 (BSD-2-Clause), do sais-lite (MIT), da implementação portátil de Ed25519 de Orson Peters (zlib) e do `SUSignatureVerifier.m` de Mark Hamlin (BSD-2-Clause). O arquivo de licença completo do Sparkle, incluindo essas licenças externas, é reproduzido literalmente:

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

O mesmo arquivo de licença é fornecido dentro do aplicativo em `AutoBrew.app/Contents/Frameworks/Sparkle.framework/Resources/LICENSE`.

### 3.3 Homebrew (dependência em tempo de execução, não incluída)

```
Component: Homebrew
License: BSD-2-Clause
Copyright: Copyright (c) 2009-present, Homebrew contributors
Repository: https://github.com/Homebrew/brew
```

O Homebrew não faz parte do pacote do aplicativo AutoBrew. O AutoBrew executa o comando `brew` da instalação do Homebrew no seu Mac e, se o Homebrew estiver ausente e você solicitar, executa o script oficial de instalação do Homebrew. O Homebrew é instalado e licenciado separadamente, sob sua própria licença BSD-2-Clause.

### 3.4 Frameworks de sistema da Apple

O AutoBrew é vinculado a frameworks que fazem parte do macOS e são utilizados nos termos do SDK da Apple, e não sob uma licença de código aberto: SwiftUI, AppKit, Foundation, Observation, UserNotifications, ServiceManagement, IOKit, CryptoKit, UniformTypeIdentifiers, WidgetKit, AppIntents e o sistema de registro unificado (`os`). Eles são listados apenas para fins de completude.

---

## 4. TEXTOS DE LICENÇA COMUNS

### 4.1 MIT License

Ver os textos completos nas Seções 3.1 e 3.2; mais informações: https://opensource.org/licenses/MIT

### 4.2 BSD 2-Clause License ("Simplified")

Os componentes licenciados sob a BSD 2-Clause License estão sujeitos aos termos disponíveis em:
https://opensource.org/licenses/BSD-2-Clause

### 4.3 zlib License

Os componentes licenciados sob a zlib License estão sujeitos aos termos disponíveis em:
https://opensource.org/licenses/Zlib

---

## 5. CONSIDERAÇÕES JURÍDICAS POR JURISDIÇÃO

### 5.1 União Europeia

- O cumprimento das licenças de código aberto é exigido pelo direito autoral da UE (Diretiva 2001/29/CE)
- A Diretiva relativa à proteção jurídica dos programas de computador (2009/24/CE) permite a descompilação para fins de interoperabilidade
- O Regulamento de Ciber-Resiliência (Regulamento (UE) 2024/2847) pode impor obrigações adicionais a softwares comerciais que incorporem componentes de código aberto

### 5.2 Alemanha

- A UrhG (Urheberrechtsgesetz) rege os direitos autorais sobre software
- As licenças de código aberto são, em geral, exigíveis nos termos do direito contratual alemão
- Tribunais alemães já fizeram cumprir a GPL e outras licenças de código aberto (por exemplo, LG München I, LG Hamburg)

### 5.3 Estados Unidos

- O Copyright Act (17 U.S.C.) rege os direitos autorais sobre software
- As licenças de código aberto são exigíveis como licenças de direitos autorais
- As disposições de porto seguro (safe harbor) do DMCA podem ser aplicáveis

### 5.4 Reino Unido

- O Copyright, Designs and Patents Act 1988 rege os direitos autorais sobre software
- As licenças de código aberto são exigíveis nos termos do direito contratual e autoral inglês

### 5.5 Japão

- A Lei de Direitos Autorais (著作権法) rege os direitos autorais sobre software
- As licenças de código aberto são reconhecidas e exigíveis

### 5.6 Outras jurisdições

- A exigibilidade das licenças de código aberto pode variar conforme a jurisdição
- O direito autoral local rege os direitos e as obrigações dos licenciados

---

## 6. ATUALIZAÇÕES

Este documento é atualizado quando novos componentes de código aberto são adicionados ou componentes existentes são atualizados. A data de "Última atualização" no topo reflete a revisão mais recente.

Atribuições ausentes ou incorretas podem ser comunicadas em https://github.com/marcelrgberger/auto-brew/issues ou pelo e-mail hello@digitalfreedom.co.za.

---

## 7. CONTATO

Para perguntas sobre componentes de código aberto, cumprimento de licenças ou solicitações de código-fonte:

DigitalFreedom
Uma marca da DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
E-mail: hello@digitalfreedom.co.za
Site: https://digitalfreedom.co.za

---

(c) 2025-2026 DigitalFreedom Global LLC. Todos os direitos reservados.

*Nota: o aviso de direitos autorais acima aplica-se a este documento em si, e não aos componentes de código aberto aqui listados, que estão sujeitos às suas respectivas licenças.*
