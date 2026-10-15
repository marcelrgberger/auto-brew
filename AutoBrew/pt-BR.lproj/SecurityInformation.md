<!-- doc-id: CRA_USER_INFORMATION | lang: en | area: apps/documents | version: 1.0.0 | valid-from: 2026-09-01 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-06-01 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/apps/documents/CRA_USER_INFORMATION.en.md | SBOM: none published (no SBOM found in the repository); portfolio transport-encryption sentence replaced by AutoBrew facts (§ 4); placeholders: APP_NAME=AutoBrew, APP_VERSION=2.5.4, BUNDLE_ID=za.co.digitalfreedom.AutoBrew, SUPPORT_END=October 2031 for 2.5.4 (GitHub release 2026-10-15) and five years from release for later versions, APP_DOMAIN: no product domain (§ 6 states that the declaration is not yet issued), AUTH_METHOD=none, storage=on the Mac; adaptations: direct distribution and Sparkle updates (§ 3, § 8), generator instruction in the header replaced by a user-facing statement, sibling links replaced by document names | translated-from: en -->
# INFORMAÇÕES DE SEGURANÇA SOBRE ESTE PRODUTO

## Informações e instruções ao usuário — Anexo II, Regulamento (UE) 2024/2847 (Regulamento de Ciber-Resiliência, Cyber Resilience Act)

**Produto:** AutoBrew, versão 2.5.4 e posteriores
**Aplicável a partir de:** o Anexo II do Regulamento de Ciber-Resiliência aplica-se aos produtos colocados no mercado da UE a partir de
**11 de dezembro de 2027** e, antes disso, a qualquer produto existente que sofra uma modificação substancial.
Estas informações são fornecidas para o AutoBrew antes dessa data.

---

## 1. Fabricante

DigitalFreedom — uma marca da DigitalFreedom Global LLC
30 N Gould St, Ste N, Sheridan, WY 82801, United States
Ponto único de contato: hello@digitalfreedom.co.za

## 2. Onde comunicar uma vulnerabilidade

Comunicações de segurança: <https://security.digitalfreedom.co.za> ou `security@digitalfreedom.co.za`.
O processo completo, incluindo o porto seguro (safe harbour), consta da Política de divulgação coordenada de vulnerabilidades (Configurações → Jurídico → Divulgação de vulnerabilidades);
em formato legível por máquina: https://digitalfreedom.co.za/.well-known/security.txt.

## 3. Identificação do produto

AutoBrew — `za.co.digitalfreedom.AutoBrew` — um aplicativo para macOS (macOS 14 ou posterior), distribuído diretamente como download notarizado a partir do GitHub Releases (https://github.com/marcelrgberger/auto-brew/releases) e por meio do tap do Homebrew `marcelrgberger/homebrew-tap`.
A versão instalada é exibida nas configurações do app, na seção Sobre, acima da área Jurídico.

## 4. Finalidade prevista e propriedades essenciais de cibersegurança

O AutoBrew mantém atualizados os pacotes Homebrew de um Mac de acordo com a política de atualização definida pelo usuário, oferece uma interface gráfica para navegar, instalar, atualizar e remover casks do Homebrew e cria, restaura e migra instantâneos dos dados de usuário de aplicativos. Propriedades de segurança: nenhum SDK de publicidade e nenhum identificador de publicidade; apenas notificações locais;
autenticação: nenhuma — o app funciona apenas localmente; armazenamento de dados: apenas no dispositivo.

Para o AutoBrew em particular: as conexões que o próprio AutoBrew abre usam HTTPS; os endereços de download dos pacotes que o Homebrew instala são definidos por seus editores e pelo projeto Homebrew. Cada versão é assinada com um certificado Apple Developer ID, notarizada pela Apple e compilada com o Hardened Runtime. As atualizações fornecidas pelo atualizador integrado (Sparkle) são verificadas com base em uma assinatura EdDSA (Ed25519) antes de serem instaladas. O AutoBrew armazena seus dados no Mac ou no local de armazenamento de instantâneos escolhido pelo usuário; ele não envia dados ao fabricante.

## 5. Circunstâncias conhecidas ou previsíveis de risco significativo de cibersegurança

- **O AutoBrew é executado fora do App Sandbox** porque precisa executar `brew`, `ditto` e outras ferramentas do sistema. Ele atua com os direitos do usuário conectado.
- **O software instalado ou atualizado por meio do Homebrew** é publicado por terceiros e é executado com os direitos do usuário. Com as atualizações automáticas ativadas, novas versões são instaladas de acordo com a política de atualização definida pelo usuário, sem confirmação separada para cada atualização da categoria "instalar automaticamente".
- **Os instantâneos contêm cópias de dados de aplicativos**, que podem incluir credenciais, tokens ou outras informações sensíveis que um aplicativo guarda em suas pastas de dados de usuário. Os instantâneos e os arquivos de instantâneos exportados não são criptografados pelo AutoBrew; qualquer pessoa com acesso ao local dos instantâneos, a uma unidade externa usada para eles ou a um arquivo exportado pode lê-los. Os instantâneos automáticos antes das atualizações estão ativados por padrão (Configurações → Instantâneos).
- **A instalação do Homebrew** a partir do AutoBrew executa o script oficial de instalação do Homebrew baixado do GitHub.

Nenhum desses pontos é uma vulnerabilidade conhecida. As circunstâncias descobertas posteriormente são tratadas por meio de atualizações de segurança e, quando atingirem os limiares do art. 14, notificadas conforme exigido.

## 6. Declaração UE de conformidade

A declaração UE de conformidade é exigida a partir de 11 de dezembro de 2027 e ainda não foi emitida para o AutoBrew. Uma vez emitida, ela estará disponível mediante solicitação pelo e-mail hello@digitalfreedom.co.za, e sua localização será indicada aqui.

## 7. Suporte técnico e período de suporte

As vulnerabilidades de segurança são tratadas e as atualizações de segurança são fornecidas **pelo menos até outubro de 2031 para a versão 2.5.4** (publicada no GitHub Releases em 15 de outubro de 2026) e, para cada versão posterior, pelo menos até o mesmo mês, cinco anos após a publicação dessa versão no GitHub Releases.
O compromisso geral e o que o "suporte" inclui constam da Política de suporte e atualizações (Configurações → Jurídico → Política de suporte e atualizações). Solicitações de suporte:
<https://support.apps.digitalfreedom.co.za>.

## 8. Uso seguro ao longo da vida útil do produto

- **Instalação e primeiro uso:** instale apenas a partir do GitHub Releases em https://github.com/marcelrgberger/auto-brew/releases ou por meio do tap do Homebrew `marcelrgberger/homebrew-tap`; o macOS verifica a assinatura Developer ID e a notarização quando o app é aberto pela primeira vez. Nenhuma configuração é necessária para um padrão seguro — o app não tem nenhum fluxo de dados opcional para o fabricante.
- **As atualizações de segurança** são fornecidas pelo atualizador integrado do AutoBrew (Configurações → Atualizações → Verificar atualizações), pelo tap do Homebrew ou como novo download a partir do GitHub Releases. Mantenha a verificação automática de atualizações ativada; se você a desativar, verifique regularmente se há atualizações — uma versão desatualizada deixa de receber correções.
- **Alterações que afetam a segurança:** conceder permissões do sistema operacional amplia aquilo a que o app pode ter acesso; o AutoBrew solicita permissão para exibir notificações, e qualquer permissão pode ser revogada a qualquer momento nos Ajustes do Sistema. Escolher um local externo de armazenamento de instantâneos, ativar a instalação automática para uma categoria de pacotes e executar comandos prévios ao instantâneo por pacote ampliam o que o AutoBrew faz em seu nome.
- **Desativação:** a desinstalação remove o app. Para remover os dados locais dele, exclua as pastas listadas na Política de privacidade, Seção 3.6, incluindo um local externo de instantâneos que você tenha escolhido e quaisquer arquivos de instantâneos exportados. O AutoBrew não tem conta e não mantém dados nos servidores do fabricante.

## 9. Lista de materiais de software (SBOM)

Nenhuma SBOM é publicada para o AutoBrew. Os componentes de terceiros e suas licenças estão listados no documento Licenças de código aberto (Configurações → Jurídico → Licenças de código aberto).
