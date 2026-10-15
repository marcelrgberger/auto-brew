<!-- doc-id: TERMS_OF_SERVICE | lang: en | area: shared | version: 2.0.1 | valid-from: 2026-10-13 | supersedes: TERMS_OF_SERVICE 2.0.0 (telephone number removed from § 14.7), 1.x; absorbs EU_CONSUMER_ANNEX, ANZ_CONSUMER_ANNEX (consumer parts, 1.0.0) | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/TERMS_OF_SERVICE.en.md | adaptations: direct distribution instead of app stores (§ 1.1.1, § 14.1, § 14.5-14.7), AutoBrew description, Homebrew and updates (§ 2.1, § 2.4, § 2.5), no accounts (§ 3), no user content sent to the Provider (§ 4), no shared resource (§ 5), free of charge (§ 7), MIT License (§ 5, § 6.1, § 12.2), sibling links replaced by in-app document names, translation count removed (§ 16.8) | translated-from: en -->
# TERMOS DE SERVIÇO

## Termos e condições gerais

**Aplicativo:** AutoBrew

**Data de vigência:** 15 de outubro de 2026

**Fornecedor:**
DigitalFreedom
Uma marca da DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contato: hello@digitalfreedom.co.za
Site: https://digitalfreedom.co.za

---

## 1. ÂMBITO E ACEITAÇÃO

### 1.1 Contrato

Estes Termos de Serviço ("Termos") regem o seu acesso ao aplicativo AutoBrew e a serviços relacionados, como o suporte ("os Serviços"), bem como o uso deles, prestados sob a marca **DigitalFreedom** pela DigitalFreedom Global LLC ("o Fornecedor").

### 1.1.1 Âmbito global

O AutoBrew é distribuído diretamente pelo Fornecedor — como download notarizado a partir do GitHub Releases e por meio do tap do Homebrew `marcelrgberger/homebrew-tap` — e não pela Apple App Store nem pela Google Play Store. Ele pode ser baixado em todos os países a partir dos quais esses canais sejam acessíveis. Estes Termos aplicam-se globalmente a todos os usuários dos Serviços, independentemente do país de acesso ou de uso. O Fornecedor adota o Regulamento Geral sobre a Proteção de Dados da União Europeia (RGPD) e o direito da UE correlato como seu padrão de referência e o aplica como patamar mínimo global; os direitos imperativos de proteção do consumidor e outros direitos legais conferidos pelo país de residência do usuário permanecem inalterados e prevalecem sempre que forem mais protetivos.

### 1.2 Aceitação

Ao acessar ou usar os Serviços, você concorda em ficar vinculado a estes Termos. Se você não concordar, não deverá usar os Serviços.

### 1.3 Capacidade

Para celebrar um contrato conosco, você deve ter capacidade jurídica para tanto segundo a lei do seu local de residência — em geral, 18 anos, e 19 anos na Coreia do Sul. Menores só podem usar os Serviços com a participação de um dos pais ou de um responsável legal que aceite estes Termos em seu nome.

Essa é uma questão diferente da idade a partir da qual você pode consentir com o tratamento dos seus dados pessoais, que é fixada entre 13 e 16 anos conforme o Estado-Membro e é tratada na Política de privacidade. Nenhum dos dois números rege o outro: o § 110 BGB, que permite a um menor celebrar alguns contratos com seus próprios meios, não abrange uma obrigação continuada, como uma assinatura.

### 1.4 Uso empresarial

Se você usar os Serviços em nome de uma organização, declara ter poderes para vincular essa organização a estes Termos.

---

## 2. SERVIÇOS

### 2.1 Descrição

O AutoBrew é um aplicativo de barra de menus para macOS que mantém os pacotes Homebrew atualizados de acordo com a política de atualização que você define, oferece uma interface gráfica para navegar, instalar, atualizar e remover casks do Homebrew e cria, restaura e migra instantâneos dos dados de usuário de aplicativos no seu Mac. Ele é:

- **De código aberto** sob a MIT License — código-fonte em https://github.com/marcelrgberger/auto-brew
- **Gratuito** — sem compras no app, sem assinaturas, sem plano pago
- **Local** — é executado no seu Mac e não exige conta nem qualquer serviço de back-end do Fornecedor

### 2.2 Modificações

O Fornecedor reserva-se o direito de modificar, suspender ou descontinuar qualquer Serviço. **Para consumidores na UE e no EEE, esse direito é limitado:** além do que for necessário para manter o Serviço em conformidade, o Serviço só é modificado por um motivo válido aqui indicado — adaptação a um novo ambiente técnico, a requisitos de plataforma alterados, a requisitos legais ou descontinuação de um serviço de terceiros do qual o recurso depende — e uma modificação que afete o seu acesso ou uso de forma mais do que insignificante é comunicada a você com antecedência em suporte duradouro, juntamente com o seu direito de rescindir gratuitamente no prazo de 30 dias caso a modificação seja prejudicial (art. 19 da Diretiva (UE) 2019/770 / § 327r BGB). Alterações relevantes são comunicadas a todos sempre que possível.

### 2.3 Disponibilidade

Os Serviços são prestados conforme a disponibilidade ("as available"). O Fornecedor não garante acesso ou disponibilidade ininterruptos.

### 2.4 Homebrew

O AutoBrew requer uma instalação funcional do Homebrew e executa o comando `brew` no seu Mac. O Fornecedor não é vinculado ao projeto Homebrew e não controla quais pacotes estão disponíveis, quando as versões são lançadas nem o que os editores de cada pacote fazem com seus instaladores. Instalar, atualizar ou remover um pacote por meio do AutoBrew é uma operação do Homebrew e do pacote em questão (ver Seções 8 a 10).

### 2.5 Atualizações

O AutoBrew atualiza-se por meio do framework Sparkle, a partir do appcast do AutoBrew publicado no GitHub. Cada atualização é assinada com uma chave EdDSA (Ed25519) e verificada antes de ser instalada. Em vez disso, você pode atualizar por meio do tap do Homebrew ou baixando manualmente uma versão mais recente.

---

## 3. CONTAS

O AutoBrew não tem contas. Nenhum cadastro é necessário, e o Fornecedor não mantém nada para você vinculado a uma conta; as Seções 3.1 a 3.3 dos termos gerais (cadastro, segurança das credenciais, suspensão de conta) não se aplicam, portanto.

---

## 4. CONTEÚDO DO USUÁRIO

O AutoBrew não envia ao Fornecedor nada do que você cria ou armazena com ele: configurações, políticas de atualização, coleções e instantâneos permanecem no seu Mac. Você continua sendo o único responsável pelos arquivos dos quais cria instantâneos, que restaura, exporta ou importa, e por ter o direito de fazê-lo. O que você envia ao Fornecedor em uma solicitação de suporte é usado apenas para respondê-la, conforme descrito na Política de privacidade.

---

## 5. USO ACEITÁVEL

Você não deverá:

- Violar qualquer lei ou regulamento aplicável
- Violar direitos de propriedade intelectual ou outros direitos de terceiros
- Transmitir malware, spam ou conteúdo nocivo
- Tentar obter acesso não autorizado aos Serviços ou a sistemas relacionados
- Interferir no funcionamento ou na segurança dos Serviços
- Usar os Serviços para fins fraudulentos ou enganosos
- Redistribuir o AutoBrew de forma diversa da prevista na MIT License, apresentar um fork como a distribuição oficial do AutoBrew ou usar as marcas AutoBrew ou DigitalFreedom em desacordo com o § 6.2

---

## 6. PROPRIEDADE INTELECTUAL

### 6.1 Propriedade intelectual do Fornecedor

Os Serviços, incluindo software, design, logotipos e documentação, são protegidos pelas leis de propriedade intelectual. O código-fonte do AutoBrew é publicado sob a MIT License, que concede os direitos nela indicados; todos os direitos não expressamente concedidos permanecem com o Fornecedor.

### 6.2 Marcas

As marcas e os nomes comerciais do Fornecedor não podem ser usados sem consentimento prévio por escrito. **AutoBrew** e **DigitalFreedom** são marcas da DigitalFreedom Global LLC; a MIT License não concede nenhum direito sobre elas. Forks e obras derivadas podem fazer referência ao AutoBrew de forma descritiva (por exemplo, "fork of AutoBrew"), mas não podem usar essas marcas como nome do seu produto, para um produto ou serviço pago concorrente, ou de forma que sugira endosso pelo Fornecedor. Os detalhes constam do Aviso sobre marcas registradas fornecido com o AutoBrew, Seção 4.

### 6.3 Feedback

Qualquer feedback ou sugestão que você fornecer poderá ser usado pelo Fornecedor sem qualquer obrigação para com você.

---

## 7. PAGAMENTOS E ASSINATURAS

O AutoBrew é gratuito. Não há compras no app nem assinaturas; portanto, as disposições dos termos gerais sobre preços, processamento de pagamentos, assinaturas, a California Automatic Renewal Law, reembolsos e o direito de arrependimento da UE para conteúdo digital pago não têm objeto enquanto o AutoBrew for gratuito.

O link **Sponsor** no AutoBrew leva ao GitHub Sponsors e é inteiramente voluntário. Uma contribuição é uma doação, é processada pelo GitHub segundo os seus próprios termos e não gera direito a recursos ou suporte.

O Fornecedor poderá introduzir, em versões futuras, recursos pagos opcionais, edições pagas ou serviços complementares pagos. As condições de qualquer oferta desse tipo, incluindo as informações ao consumidor que ela exigir, são publicadas antes de ela ser oferecida; o seu direito de continuar usando uma versão gratuita que você já instalou permanece inalterado.

---

## 8. SERVIÇOS DE TERCEIROS

### 8.1 Integração

Os Serviços podem integrar-se a serviços de terceiros ou conter links para eles. O Fornecedor não endossa nem controla esses serviços.

### 8.2 Termos

O seu uso de serviços de terceiros está sujeito aos respectivos termos e políticas de privacidade.

### 8.3 Responsabilidade

O Fornecedor não responde por quaisquer danos resultantes do seu uso de serviços de terceiros.

---

## 9. EXCLUSÃO DE GARANTIAS

NA MÁXIMA EXTENSÃO PERMITIDA POR LEI:

- Os Serviços são prestados "NO ESTADO EM QUE SE ENCONTRAM" ("AS IS") e "CONFORME A DISPONIBILIDADE" ("AS AVAILABLE")
- O Fornecedor se exime de todas as garantias, expressas ou implícitas
- Não há garantia de exatidão, completude, confiabilidade ou adequação a uma finalidade específica
- Não há garantia de que os Serviços serão ininterruptos, seguros ou livres de erros

Nada nesta seção exclui ou limita qualquer garantia ou responsabilidade que não possa ser excluída ou limitada nos termos de normas imperativas aplicáveis, incluindo os direitos legais imperativos de garantia do consumidor. **Para consumidores na Austrália e na Nova Zelândia, aplica-se o § 14.5, que prevalece sobre esta seção.**

---

## 10. LIMITAÇÃO DE RESPONSABILIDADE

NA MÁXIMA EXTENSÃO PERMITIDA POR LEI:

- O Fornecedor não responde por danos indiretos, incidentais, especiais, consequenciais ou punitivos
- O Fornecedor não responde por perda de dados, lucros, receitas ou oportunidades de negócio
- A responsabilidade total agregada não excederá o maior dos seguintes valores: (a) o valor pago por você nos 12 meses anteriores à reclamação ou (b) EUR 100

**Exceções obrigatórias.** As exclusões e limitações acima **não** se aplicam aos casos a seguir, pelos quais o Fornecedor permanece integralmente responsável: (a) danos decorrentes de dolo ou culpa grave; (b) lesão à vida, ao corpo ou à saúde; (c) responsabilidade nos termos da legislação imperativa de responsabilidade pelo produto (incluindo a lei alemã de responsabilidade pelo produto / Produkthaftungsgesetz); (d) o descumprimento culposo de uma obrigação contratual essencial (obrigação cardinal / *Kardinalpflicht*) — neste caso, a responsabilidade por culpa leve limita-se ao dano previsível e típico do contrato; e (e) qualquer outra responsabilidade que não possa ser limitada ou excluída nos termos de normas imperativas aplicáveis. Os direitos legais imperativos do consumidor permanecem inalterados. **Para consumidores na Austrália e na Nova Zelândia, aplica-se o § 14.5, que prevalece sobre esta seção.**

---

## 11. INDENIZAÇÃO

Na medida permitida pela lei aplicável, você concorda em indenizar e isentar o Fornecedor de reclamações de terceiros, danos, perdas e despesas (incluindo honorários advocatícios razoáveis) na medida em que sejam causados por sua conduta culposa (dolosa ou negligente), em especial:

- Seu uso ilícito dos Serviços
- Sua violação culposa destes Termos
- Sua violação de qualquer lei ou de direitos de terceiros
- Os arquivos dos quais você cria instantâneos, que restaura, exporta ou importa com o AutoBrew

Essa obrigação não se aplica quando e na medida em que você não for responsável pela violação em questão, e não afeta nem reduz os seus direitos legais imperativos como consumidor.

---

## 12. RESCISÃO

### 12.1 Por você

Você pode deixar de usar os Serviços a qualquer momento, desinstalando o AutoBrew. A remoção do AutoBrew, de sua pasta `~/Library/Application Support/AutoBrew/`, da pasta `AutoBrew/Snapshots/` em um local externo de instantâneos que você tenha escolhido e de seu arquivo de configurações `~/Library/Preferences/za.co.digitalfreedom.AutoBrew.plist` remove os dados que o AutoBrew mantém; a Política de privacidade, Seção 3.6, lista todos os locais.

### 12.2 Pelo Fornecedor

O Fornecedor pode suspender ou encerrar o seu acesso por justa causa — incluindo uma violação relevante destes Termos, o uso indevido dos Serviços ou quando exigido por lei, por um tribunal ou autoridade, ou por um operador de plataforma. Uma violação relevante pode resultar em rescisão imediata. Quando o Fornecedor rescindir sem justa causa, ele dará aviso prévio razoável quando legalmente exigido. Os direitos legais imperativos de rescisão, seus e do Fornecedor, permanecem inalterados. Os direitos de que você é titular nos termos da MIT License não são afetados.

### 12.3 Efeitos da rescisão

Após a rescisão:

- O seu direito de usar os Serviços cessa, exceto na medida permitida pela MIT License
- As disposições que, por sua natureza, devam subsistir continuarão em vigor (incluindo limitações de responsabilidade, indenização e lei aplicável)

---

## 13. LEI APLICÁVEL E RESOLUÇÃO DE LITÍGIOS

### 13.1 Lei aplicável

Estes Termos são regidos pelas leis do Estado de Wyoming, Estados Unidos da América, excluídas as suas normas de conflito de leis e a Convenção das Nações Unidas sobre Contratos de Compra e Venda Internacional de Mercadorias. Se você for consumidor, essa escolha de lei não o priva da proteção das disposições imperativas da lei do país da sua residência habitual (art. 6(2) do Regulamento Roma I e normas equivalentes).

### 13.2 Foro

Para usuários que não sejam consumidores, os tribunais do Condado de Sheridan, Wyoming, Estados Unidos, têm competência exclusiva. Os consumidores podem propor ações perante os tribunais do país da sua residência habitual e só podem ser demandados pelo Fornecedor perante esses tribunais.

### 13.3 Litígios de consumo (UE)

A plataforma de resolução de litígios em linha da Comissão Europeia encerrou suas atividades em 20 de julho de 2025, após a revogação do Regulamento (UE) n.º 524/2013 pelo Regulamento (UE) 2024/3228. Os consumidores podem contatar o Fornecedor diretamente pelo e-mail hello@digitalfreedom.co.za. O Fornecedor não é obrigado nem está disposto a participar de procedimentos de resolução de litígios perante uma entidade de conciliação de consumo, salvo quando exigido por lei.

---

## 14. DISPOSIÇÕES REGIONAIS

### 14.1 União Europeia e EEE

**Aplica-se a:** consumidores com residência habitual na UE ou no EEE (incluindo Noruega, Islândia e Liechtenstein).

**Quem fornece o AutoBrew.** O AutoBrew é fornecido gratuitamente e diretamente pelo Fornecedor. Nenhuma loja de apps está envolvida, e não há compra.

**Arrependimento.** As disposições sobre o direito de arrependimento do § 7 dizem respeito a conteúdo digital pago; enquanto o AutoBrew for gratuito, elas não têm objeto. As informações sobre o direito de arrependimento relativas a qualquer futura oferta paga serão fornecidas com essa oferta.

**Conformidade e atualizações.** A Diretiva (UE) 2019/770 rege o fornecimento do conteúdo e do serviço digitais entre você e o Fornecedor. Os requisitos de conformidade dos arts. 6.º a 8.º e o dever de atualização do art. 8.º(2) são imperativos nos termos do art. 22 e não são excluídos por nada nestes Termos — ver a Política de suporte e atualizações (Configurações → Jurídico → Política de suporte e atualizações).

**Para consumidores na UE/no EEE, não se aplicam:**

- qualquer exclusão ou limitação de responsabilidade além das exceções obrigatórias indicadas no § 10;
- qualquer modificação do Serviço além do que o § 2.2 permite em relação a você;
- qualquer aceitação presumida de termos alterados apenas pelo silêncio ou pelo uso continuado;
- a renovação automática de um prazo anual por mais um ano completo;
- qualquer escolha de lei que afaste as proteções imperativas da sua residência habitual (art. 6(2) Roma I);
- qualquer cláusula que torne a versão em inglês vinculativa quando a lei do seu Estado-Membro exigir o idioma local (o § 16.8 estabelece a regra sobre o idioma prevalecente).

**Especificidades nacionais.**

- **Alemanha:** os deveres de identificação nos termos do § 5 DDG e do § 18(2) MStV são cumpridos no Impressum (no AutoBrew, em Configurações → Jurídico → Editor responsável). O § 308 n.º 5 e o § 309 n.º 9 BGB aplicam-se a estes Termos como termos de consumo. O botão de cancelamento previsto no § 312k BGB refere-se a contratos que os consumidores podem celebrar por meio de um site; o Fornecedor atualmente não celebra nenhum contrato dessa forma para o AutoBrew.
- **França:** as informações ao consumidor são fornecidas em francês; para um consumidor residente na França, prevalece a versão francesa (Loi Toubon; § 16.8).
- **Bélgica, Polônia:** requisitos de idioma local comparáveis à regra francesa; aplica-se o § 16.8.
- **Itália, Espanha, Áustria:** quanto à idade do consentimento digital (14 anos), ver a Política de privacidade.

### 14.2 Estados Unidos

- Quando proibidas pela lei estadual, as limitações de responsabilidade ou de garantias não se aplicam

### 14.3 Reino Unido

- Aplicam-se as proteções do Consumer Rights Act 2015
- A responsabilidade por morte ou lesão corporal causada por negligência não é excluída

### 14.4 Canadá

- A legislação provincial de proteção do consumidor pode prevalecer sobre determinadas disposições
- Para residentes de Quebec, prevalece a versão francesa quando a lei de Quebec assim exigir (§ 16.8)

### 14.5 Austrália e Nova Zelândia

<!-- verbatim: ACL-prescribed-form | no-translate -->
> Our goods and services come with guarantees that cannot be excluded under the Australian Consumer Law. For major failures with the service, you are entitled:
>
> - to cancel your service contract with us; and
> - to a refund for the unused portion, or to compensation for its reduced value.
>
> You are also entitled to choose a refund or replacement for major failures with goods. If a failure with the goods or a service does not amount to a major failure, you are entitled to have the failure rectified in a reasonable time. If this is not done you are entitled to a refund for the goods and to cancel the contract for the service and obtain a refund of any unused portion. You are also entitled to be compensated for any other reasonably foreseeable loss or damage from a failure in the goods or service.
<!-- /verbatim -->

O aviso acima qualifica os §§ 9 e 10 destes Termos e prevalece sobre eles.

**As garantias.** Para produtos e serviços digitais fornecidos a um consumidor, a Australian Consumer Law garante qualidade aceitável (s. 54), adequação a qualquer finalidade informada (s. 55), correspondência com a descrição (s. 56), diligência e competência devidas (s. 60) e adequação dos serviços à finalidade especificada (s. 61); o Consumer Guarantees Act 1993 da Nova Zelândia prevê os equivalentes (ss. 6, 8, 9, 28, 29). Quando uma falha for **grave** (major), você escolhe entre reembolso e substituição — e não o fornecedor. Quando não for grave, o fornecedor pode reparar em um prazo razoável. A Seção 64 da ACL torna nula qualquer tentativa de excluir, restringir ou modificar essas garantias; a s. 43 do CGA faz o mesmo na Nova Zelândia.

**Quem as deve.** O fornecedor é o **Fornecedor**: o AutoBrew é fornecido diretamente pela DigitalFreedom Global LLC, sem que uma loja atue como vendedora ou agente, e as garantias, os remédios para falhas graves e o aviso acima são devidos diretamente pelo Fornecedor. O canal é o contato de suporte (§ 16).

### 14.6 Turquia

O AutoBrew é fornecido gratuitamente e diretamente pelo Fornecedor; nenhuma loja atua como vendedora. Caso seja introduzida uma oferta paga, os deveres de informação pré-contratual e de arrependimento em 14 dias previstos na Lei de Proteção do Consumidor (n.º 6502) e no Regulamento sobre Contratos à Distância recaem sobre o Fornecedor. Os litígios de consumo abaixo do limite legal devem ser submetidos a um **Comitê de Arbitragem do Consumidor** antes de um tribunal; isso é obrigatório, nada nestes Termos o afasta, e qualifica a ressalva "salvo quando exigido por lei" do § 13.3.

### 14.7 Japão

Para vendas a consumidores no Japão, a Lei sobre Transações Comerciais Específicas (特定商取引法) exige que o nome, o endereço e os dados de contato do vendedor, o preço e as condições de cancelamento estejam prontamente disponíveis. O AutoBrew é fornecido diretamente pelo Fornecedor; portanto, esses deveres de exibição recaem sobre o Fornecedor e são cumpridos no Impressum (no AutoBrew, em Configurações → Jurídico → Editor responsável).

### 14.8 Outras jurisdições

- Quando normas imperativas locais restringirem qualquer disposição, essa disposição aplica-se apenas na medida permitida
- As proteções imperativas do consumidor da sua residência habitual permanecem inalteradas em todos os lugares

## 15. FORÇA MAIOR

Nenhuma das partes é responsável por atraso ou falha no cumprimento de qualquer obrigação prevista nestes Termos na medida em que o atraso ou a falha seja causado por eventos fora do seu controle razoável, incluindo, entre outros, eventos da natureza, guerra, distúrbios civis, terrorismo, ataque cibernético, ato governamental, pandemia, incêndio, inundação, interrupção prolongada de energia ou de telecomunicações ou falha da infraestrutura de suboperadores a montante. A parte afetada notificará a outra sem demora injustificada e envidará esforços razoáveis para mitigar os efeitos.

Esta Seção não afeta a obrigação de pagar valores já devidos, nem qualquer direito imperativo de proteção do consumidor do país de residência do usuário.

---

## 16. DISPOSIÇÕES GERAIS

### 16.1 Autonomia das disposições

Se qualquer disposição for considerada inválida, as demais disposições continuam em pleno vigor.

### 16.2 Renúncia

A falta de exigência do cumprimento de qualquer disposição não constitui renúncia.

### 16.3 Cessão

O Fornecedor pode ceder estes Termos no contexto de uma fusão, aquisição, reorganização societária ou venda de ativos. Os usuários serão informados com pelo menos 30 dias de antecedência sobre qualquer mudança da entidade contratante e, quando exigido por lei, será solicitado um novo consentimento. Você não pode ceder sem consentimento prévio por escrito.

### 16.4 Integralidade do contrato

Estes Termos, juntamente com a Política de privacidade, o EULA, a Visão geral do quadro jurídico, a Política de suporte e atualizações, a Política de divulgação de vulnerabilidades, o Aviso sobre marcas registradas e as Licenças de código aberto fornecidos com o AutoBrew (Configurações → Jurídico), e a MIT License sob a qual o código-fonte do AutoBrew é publicado, constituem o acordo integral entre você e o Fornecedor.

### 16.5 Alterações

O Fornecedor pode atualizar estes Termos. Alterações relevantes são comunicadas com pelo menos 30 dias de antecedência por meio dos Serviços ou por e-mail e, quando a legislação de proteção do consumidor aplicável o exigir, só entram em vigor mediante nova aceitação. O uso continuado após alterações não relevantes constitui aceitação.

### 16.6 Prazo prescricional

As pretensões decorrentes destes Termos estão sujeitas aos prazos prescricionais legais da lei aplicável. Isso não afeta qualquer prazo prescricional imperativo do país de residência do usuário.

### 16.7 Notificações

As notificações ao Fornecedor devem ser enviadas para `hello@digitalfreedom.co.za` (geral) ou `data-protection@digitalfreedom.co.za` (privacidade / DSGVO). As notificações a você podem ser feitas no AutoBrew ou em suas notas de versão, ou por e-mail, caso você tenha contatado o Fornecedor por e-mail.

### 16.8 Idioma

Estes Termos são publicados em vários idiomas. **Para um consumidor, prevalece a versão em um idioma oficial do seu local de residência habitual**, quando essa versão existir. A versão em inglês prevalece para clientes empresariais e para os idiomas nos quais não exista uma versão. Isso é o inverso da cláusula usual e é deliberado: uma cláusula que torne o inglês vinculativo não se sustenta na França, na Bélgica, na Polônia, na Itália, em Quebec ou na Turquia, e declarar as traduções não vinculativas desvalorizaria a razão de produzi-las.

---

Suporte: support@digitalfreedom.co.za · https://support.apps.digitalfreedom.co.za

(c) 2025-2026 DigitalFreedom Global LLC. Todos os direitos reservados.
