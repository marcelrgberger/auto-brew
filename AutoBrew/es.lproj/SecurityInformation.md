<!-- doc-id: CRA_USER_INFORMATION | lang: en | area: apps/documents | version: 1.0.0 | valid-from: 2026-09-01 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-06-01 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/apps/documents/CRA_USER_INFORMATION.en.md | SBOM: none published (no SBOM found in the repository); portfolio transport-encryption sentence replaced by AutoBrew facts (§ 4); placeholders: APP_NAME=AutoBrew, APP_VERSION=2.5.3, BUNDLE_ID=za.co.digitalfreedom.AutoBrew, SUPPORT_END=October 2031 for 2.5.3 (GitHub release 2026-10-15) and five years from release for later versions, APP_DOMAIN: no product domain (§ 6 states that the declaration is not yet issued), AUTH_METHOD=none, storage=on the Mac; adaptations: direct distribution and Sparkle updates (§ 3, § 8), generator instruction in the header replaced by a user-facing statement, sibling links replaced by document names | translated-from: en -->
# INFORMACIÓN DE SEGURIDAD DE ESTE PRODUCTO

## Información e instrucciones para el usuario — Anexo II, Reglamento (UE) 2024/2847 (Reglamento de Ciberresiliencia)

**Producto:** AutoBrew, versión 2.5.3 y posteriores
**Aplicable desde:** el Anexo II del Reglamento de Ciberresiliencia se aplica a los productos introducidos en el mercado de la UE a partir del
**11 de diciembre de 2027**, y antes a cualquier producto existente que sea objeto de una modificación sustancial.
Esta información se facilita para AutoBrew con antelación a esa fecha.

---

## 1. Fabricante

DigitalFreedom — una marca de DigitalFreedom Global LLC
30 N Gould St, Ste N, Sheridan, WY 82801, United States
Punto único de contacto: hello@digitalfreedom.co.za

## 2. Dónde notificar una vulnerabilidad

Notificaciones de seguridad: <https://security.digitalfreedom.co.za> o `security@digitalfreedom.co.za`.
El proceso completo, incluido el puerto seguro (safe harbour), figura en la Política de divulgación coordinada de vulnerabilidades (Ajustes → Legal → Divulgación de vulnerabilidades);
en formato legible por máquina: https://digitalfreedom.co.za/.well-known/security.txt.

## 3. Identificación del producto

AutoBrew — `za.co.digitalfreedom.AutoBrew` — una aplicación para macOS (macOS 14 o posterior), distribuida directamente como descarga notarizada desde GitHub Releases (https://github.com/marcelrgberger/auto-brew/releases) y a través del tap de Homebrew `marcelrgberger/homebrew-tap`.
La versión instalada se muestra en los ajustes de la aplicación, en la sección Acerca de, encima del área Legal.

## 4. Finalidad prevista y propiedades esenciales de ciberseguridad

AutoBrew mantiene actualizados los paquetes de Homebrew de un Mac según la política de actualización que establezca el usuario, ofrece una interfaz gráfica para explorar, instalar, actualizar y eliminar casks de Homebrew, y crea, restaura y migra instantáneas de los datos de usuario de las aplicaciones. Propiedades de seguridad: sin SDK publicitario y sin identificador publicitario; solo notificaciones locales;
autenticación: ninguna, la aplicación funciona exclusivamente en local; almacenamiento de datos: solo en el dispositivo.

En el caso concreto de AutoBrew: las conexiones que abre el propio AutoBrew utilizan HTTPS; las direcciones de descarga de los paquetes que instala Homebrew las establecen sus editores y el proyecto Homebrew. Cada versión está firmada con un certificado Apple Developer ID, notarizada por Apple y compilada con Hardened Runtime. Las actualizaciones que se proporcionan a través del actualizador integrado (Sparkle) se verifican mediante una firma EdDSA (Ed25519) antes de instalarse. AutoBrew almacena sus datos en el Mac o en la ubicación de almacenamiento de instantáneas que elija el usuario; no envía ningún dato al fabricante.

## 5. Circunstancias conocidas o previsibles de riesgo significativo de ciberseguridad

- **AutoBrew se ejecuta fuera del App Sandbox** porque tiene que ejecutar `brew`, `ditto` y otras herramientas del sistema. Actúa con los permisos del usuario que ha iniciado sesión.
- **El software instalado o actualizado a través de Homebrew** lo publican terceros y se ejecuta con los permisos del usuario. Con las actualizaciones automáticas activadas, las nuevas versiones se instalan según la política de actualización establecida por el usuario, sin una confirmación separada para cada actualización de la categoría "instalar automáticamente".
- **Las instantáneas contienen copias de datos de aplicaciones**, que pueden incluir credenciales, tokens u otra información sensible que una aplicación guarde en sus carpetas de datos de usuario. AutoBrew no cifra las instantáneas ni los archivos de instantáneas exportados; cualquier persona con acceso a la ubicación de las instantáneas, a una unidad externa utilizada para ellas o a un archivo exportado puede leerlos. Las instantáneas automáticas antes de las actualizaciones están activadas de forma predeterminada (Ajustes → Instantáneas).
- **La instalación de Homebrew** desde AutoBrew ejecuta el script oficial de instalación de Homebrew descargado de GitHub.

Ninguna de ellas es una vulnerabilidad conocida. Las circunstancias que se descubran más adelante se abordan mediante actualizaciones de seguridad y, cuando alcancen los umbrales del art. 14, se notifican según lo exigido.

## 6. Declaración UE de conformidad

La declaración UE de conformidad es obligatoria a partir del 11 de diciembre de 2027 y aún no se ha emitido para AutoBrew. Una vez emitida, estará disponible previa solicitud en hello@digitalfreedom.co.za y su ubicación se indicará aquí.

## 7. Soporte técnico y periodo de soporte

Las vulnerabilidades de seguridad se gestionan y se proporcionan actualizaciones de seguridad **al menos hasta octubre de 2031 para la versión 2.5.3** (publicada en GitHub Releases el 15 de octubre de 2026) y, para cada versión posterior, al menos hasta el mismo mes cinco años después de que esa versión se publique en GitHub Releases.
El compromiso general y lo que incluye el "soporte" figuran en la Política de soporte y actualizaciones (Ajustes → Legal → Política de soporte y actualizaciones). Solicitudes de soporte:
<https://support.apps.digitalfreedom.co.za>.

## 8. Uso seguro durante la vida útil del producto

- **Instalación y primer uso:** instale únicamente desde GitHub Releases en https://github.com/marcelrgberger/auto-brew/releases o a través del tap de Homebrew `marcelrgberger/homebrew-tap`; macOS verifica la firma Developer ID y la notarización la primera vez que se abre la aplicación. No se necesita ninguna configuración para obtener un estado seguro predeterminado: la aplicación no tiene ningún flujo de datos opcional hacia el fabricante.
- **Las actualizaciones de seguridad** se proporcionan a través del actualizador integrado de AutoBrew (Ajustes → Actualizaciones → Buscar actualizaciones), a través del tap de Homebrew o como nueva descarga desde GitHub Releases. Mantenga activada la búsqueda automática de actualizaciones; si la desactiva, busque actualizaciones con regularidad: una versión obsoleta ya no recibe correcciones.
- **Cambios que afectan a la seguridad:** conceder permisos del sistema operativo amplía aquello a lo que puede acceder la aplicación; AutoBrew solicita permiso para mostrar notificaciones, y cualquier permiso puede revocarse en cualquier momento en Ajustes del Sistema. Elegir una ubicación externa para las instantáneas, activar la instalación automática para una categoría de paquetes y ejecutar comandos previos a la instantánea por paquete amplían lo que AutoBrew hace en su nombre.
- **Puesta fuera de servicio:** al desinstalar se elimina la aplicación. Para eliminar sus datos locales, borre las carpetas indicadas en la Política de privacidad, Sección 3.6, incluida una ubicación externa de instantáneas que haya elegido y los archivos de instantáneas exportados. AutoBrew no tiene cuentas y no conserva datos en los servidores del fabricante.

## 9. Lista de materiales de software

No se publica ninguna SBOM para AutoBrew. Los componentes de terceros y sus licencias figuran en el documento Licencias de código abierto (Ajustes → Legal → Licencias de código abierto).
