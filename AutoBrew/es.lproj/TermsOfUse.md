<!-- doc-id: TERMS_OF_SERVICE | lang: en | area: shared | version: 2.0.1 | valid-from: 2026-10-13 | supersedes: TERMS_OF_SERVICE 2.0.0 (telephone number removed from § 14.7), 1.x; absorbs EU_CONSUMER_ANNEX, ANZ_CONSUMER_ANNEX (consumer parts, 1.0.0) | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/TERMS_OF_SERVICE.en.md | adaptations: direct distribution instead of app stores (§ 1.1.1, § 14.1, § 14.5-14.7), AutoBrew description, Homebrew and updates (§ 2.1, § 2.4, § 2.5), no accounts (§ 3), no user content sent to the Provider (§ 4), no shared resource (§ 5), free of charge (§ 7), MIT License (§ 5, § 6.1, § 12.2), sibling links replaced by in-app document names, translation count removed (§ 16.8) | translated-from: en -->
# CONDICIONES DEL SERVICIO

## Condiciones generales

**Aplicación:** AutoBrew

**Fecha de entrada en vigor:** 15 de octubre de 2026

**Prestador:**
DigitalFreedom
Una marca de DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contacto: hello@digitalfreedom.co.za
Sitio web: https://digitalfreedom.co.za

---

## 1. ÁMBITO DE APLICACIÓN Y ACEPTACIÓN

### 1.1 Contrato

Las presentes Condiciones del Servicio ("Condiciones") rigen su acceso a la aplicación AutoBrew y a los servicios relacionados, como el soporte ("los Servicios"), y su uso, prestados bajo la marca **DigitalFreedom** por DigitalFreedom Global LLC ("el Prestador").

### 1.1.1 Ámbito global

AutoBrew se distribuye directamente por el Prestador —como descarga notarizada desde GitHub Releases y a través del tap de Homebrew `marcelrgberger/homebrew-tap`— y no a través de la Apple App Store ni de Google Play Store. Puede descargarse en todos los países desde los que se pueda acceder a estos canales. Las presentes Condiciones se aplican a nivel mundial a todos los usuarios de los Servicios, con independencia del país de acceso o de uso. El Prestador adopta el Reglamento General de Protección de Datos de la Unión Europea (RGPD) y el derecho de la UE relacionado como norma de referencia y lo aplica como mínimo global; los derechos imperativos de protección de los consumidores y demás derechos legales que otorgue el país de residencia del usuario no se ven afectados y prevalecen siempre que sean más protectores.

### 1.2 Aceptación

Al acceder a los Servicios o utilizarlos, usted acepta quedar vinculado por las presentes Condiciones. Si no está de acuerdo, no debe utilizar los Servicios.

### 1.3 Capacidad

Para celebrar un contrato con nosotros debe tener capacidad jurídica para ello conforme a la ley de su lugar de residencia: por lo general, 18 años, y 19 en Corea del Sur. Los menores solo pueden utilizar los Servicios con la intervención de un progenitor o tutor que acepte las presentes Condiciones en su nombre.

Se trata de una cuestión distinta de la edad a partir de la cual usted puede consentir el tratamiento de sus datos personales, que se fija entre los 13 y los 16 años según el Estado miembro y se regula en la Política de privacidad. Ninguna de las dos cifras determina la otra: el § 110 BGB, que permite a un menor celebrar algunos contratos con sus propios medios, no abarca una obligación continuada como una suscripción.

### 1.4 Uso empresarial

Si utiliza los Servicios en nombre de una organización, declara que tiene facultades para obligar a dicha organización con respecto a las presentes Condiciones.

---

## 2. SERVICIOS

### 2.1 Descripción

AutoBrew es una aplicación para la barra de menús de macOS que mantiene actualizados los paquetes de Homebrew según la política de actualización que usted establezca, ofrece una interfaz gráfica para explorar, instalar, actualizar y eliminar casks de Homebrew, y crea, restaura y migra instantáneas de los datos de usuario de las aplicaciones en su Mac. Es:

- **De código abierto** bajo la Licencia MIT; código fuente en https://github.com/marcelrgberger/auto-brew
- **Gratuita**: sin compras dentro de la aplicación, sin suscripciones, sin nivel de pago
- **Local**: se ejecuta en su Mac y no requiere cuenta ni ningún servicio de backend del Prestador

### 2.2 Modificaciones

El Prestador se reserva el derecho a modificar, suspender o interrumpir cualquier Servicio. **Para los consumidores de la UE y del EEE, este derecho está limitado:** más allá de lo necesario para mantener la conformidad del Servicio, este solo se modifica por un motivo válido indicado aquí —adaptación a un nuevo entorno técnico, a requisitos modificados de la plataforma o a requisitos legales, o la interrupción de un servicio de terceros del que dependa la función— y toda modificación que afecte de forma no insignificante a su acceso o uso se le notifica con antelación en un soporte duradero, junto con su derecho a resolver el contrato gratuitamente en un plazo de 30 días si la modificación le resulta perjudicial (art. 19 de la Directiva (UE) 2019/770 / § 327r BGB). Los cambios significativos se comunican a todos cuando sea factible.

### 2.3 Disponibilidad

Los Servicios se prestan "según disponibilidad". El Prestador no garantiza un acceso o una disponibilidad ininterrumpidos.

### 2.4 Homebrew

AutoBrew requiere una instalación operativa de Homebrew y ejecuta el comando `brew` en su Mac. El Prestador no está vinculado al proyecto Homebrew y no controla qué paquetes están disponibles, cuándo se publican las versiones ni lo que hacen los editores de cada paquete con sus instaladores. Instalar, actualizar o eliminar un paquete a través de AutoBrew es una operación de Homebrew y del paquete correspondiente (véanse las Secciones 8 a 10).

### 2.5 Actualizaciones

AutoBrew se actualiza a sí mismo mediante el framework Sparkle a partir del appcast de AutoBrew publicado en GitHub. Cada actualización está firmada con una clave EdDSA (Ed25519) y se verifica antes de instalarse. También puede actualizar a través del tap de Homebrew o descargando manualmente una versión más reciente.

---

## 3. CUENTAS

AutoBrew no tiene cuentas. No se requiere registro y el Prestador no guarda nada para usted en una cuenta; por tanto, las Secciones 3.1 a 3.3 de las condiciones generales (registro, seguridad de las credenciales, suspensión de la cuenta) no son aplicables.

---

## 4. CONTENIDO DEL USUARIO

AutoBrew no envía al Prestador nada de lo que usted cree o almacene con él: los ajustes, las políticas de actualización, las colecciones y las instantáneas permanecen en su Mac. Usted sigue siendo el único responsable de los archivos de los que crea instantáneas, que restaura, exporta o importa, y de tener derecho a hacerlo. Lo que envíe al Prestador en una solicitud de soporte se utiliza únicamente para responderla, tal como se describe en la Política de privacidad.

---

## 5. USO ACEPTABLE

Usted no podrá:

- Infringir ninguna ley o normativa aplicable
- Vulnerar derechos de propiedad intelectual u otros derechos de terceros
- Transmitir malware, spam o contenidos dañinos
- Intentar obtener acceso no autorizado a los Servicios o a sistemas relacionados
- Interferir en el funcionamiento o la seguridad de los Servicios
- Utilizar los Servicios con fines fraudulentos o engañosos
- Redistribuir AutoBrew de forma distinta a la prevista en la Licencia MIT, presentar un fork como la distribución oficial de AutoBrew o utilizar las marcas AutoBrew o DigitalFreedom en contra de lo dispuesto en el § 6.2

---

## 6. PROPIEDAD INTELECTUAL

### 6.1 Propiedad intelectual del Prestador

Los Servicios, incluidos el software, el diseño, los logotipos y la documentación, están protegidos por la legislación de propiedad intelectual. El código fuente de AutoBrew se publica bajo la Licencia MIT, que concede los derechos que en ella se indican; todos los derechos no concedidos expresamente siguen correspondiendo al Prestador.

### 6.2 Marcas

Las marcas y nombres comerciales del Prestador no pueden utilizarse sin consentimiento previo por escrito. **AutoBrew** y **DigitalFreedom** son marcas de DigitalFreedom Global LLC; la Licencia MIT no concede derechos sobre ellas. Los forks y derivados pueden referirse a AutoBrew de forma descriptiva (por ejemplo, "fork of AutoBrew"), pero no pueden utilizar estas marcas como nombre de su producto, para un producto o servicio de pago competidor ni de un modo que sugiera el respaldo del Prestador. Los detalles se recogen en el Aviso sobre marcas que se distribuye con AutoBrew, Sección 4.

### 6.3 Comentarios

Cualquier comentario o sugerencia que usted facilite podrá ser utilizado por el Prestador sin obligación alguna hacia usted.

---

## 7. PAGOS Y SUSCRIPCIONES

AutoBrew es gratuito. No hay compras dentro de la aplicación ni suscripciones, por lo que las disposiciones de las condiciones generales sobre precios, procesamiento de pagos, suscripciones, la California Automatic Renewal Law, reembolsos y el derecho de desistimiento de la UE para contenidos digitales de pago carecen de objeto mientras AutoBrew sea gratuito.

El enlace **Sponsor** de AutoBrew lleva a GitHub Sponsors y es totalmente voluntario. Una contribución es una donación, la gestiona GitHub conforme a sus propias condiciones y no genera derecho alguno a funciones ni a soporte.

El Prestador podrá introducir en futuras versiones funciones de pago opcionales, ediciones de pago o servicios complementarios de pago. Las condiciones de cualquier oferta de este tipo, incluida la información al consumidor que requiera, se publicarán antes de ofrecerla; su derecho a seguir utilizando una versión gratuita que ya haya instalado no se ve afectado.

---

## 8. SERVICIOS DE TERCEROS

### 8.1 Integración

Los Servicios pueden integrarse con servicios de terceros o enlazar a ellos. El Prestador no respalda ni controla dichos servicios.

### 8.2 Condiciones

Su uso de servicios de terceros está sujeto a sus respectivas condiciones y políticas de privacidad.

### 8.3 Responsabilidad

El Prestador no responde de los daños derivados de su uso de servicios de terceros.

---

## 9. EXCLUSIÓN DE GARANTÍAS

EN LA MÁXIMA MEDIDA PERMITIDA POR LA LEY:

- Los Servicios se prestan "TAL CUAL" y "SEGÚN DISPONIBILIDAD"
- El Prestador excluye toda garantía, expresa o implícita
- No se garantiza la exactitud, integridad, fiabilidad ni idoneidad para un fin determinado
- No se garantiza que los Servicios sean ininterrumpidos, seguros o estén libres de errores

Nada de lo dispuesto en esta sección excluye ni limita ninguna garantía o responsabilidad que no pueda excluirse ni limitarse conforme a las normas imperativas aplicables, incluidos los derechos legales imperativos de garantía de los consumidores. **Para los consumidores de Australia y Nueva Zelanda se aplica el § 14.5, que prevalece sobre esta sección.**

---

## 10. LIMITACIÓN DE RESPONSABILIDAD

EN LA MÁXIMA MEDIDA PERMITIDA POR LA LEY:

- El Prestador no será responsable de daños indirectos, incidentales, especiales, consecuenciales o punitivos
- El Prestador no será responsable de la pérdida de datos, beneficios, ingresos u oportunidades de negocio
- La responsabilidad total acumulada no excederá del mayor de los siguientes importes: (a) el importe pagado por usted en los 12 meses anteriores a la reclamación, o (b) 100 EUR

**Excepciones imperativas.** Las exclusiones y limitaciones anteriores **no** se aplican a los siguientes supuestos, de los que el Prestador sigue respondiendo plenamente: (a) daños derivados de dolo o culpa grave; (b) daños a la vida, la integridad física o la salud; (c) responsabilidad conforme a la normativa imperativa sobre responsabilidad por productos defectuosos (incluida la Ley alemana de responsabilidad por productos / Produkthaftungsgesetz); (d) el incumplimiento culpable de una obligación contractual esencial (obligación cardinal / *Kardinalpflicht*); en este caso, la responsabilidad por culpa leve se limita al daño previsible y típico del contrato; y (e) cualquier otra responsabilidad que no pueda limitarse ni excluirse conforme a las normas imperativas aplicables. Los derechos legales imperativos de los consumidores no se ven afectados. **Para los consumidores de Australia y Nueva Zelanda se aplica el § 14.5, que prevalece sobre esta sección.**

---

## 11. INDEMNIZACIÓN

En la medida permitida por la legislación aplicable, usted se compromete a indemnizar y mantener indemne al Prestador frente a reclamaciones de terceros, daños, pérdidas y gastos (incluidos los honorarios de abogados razonables) en la medida en que sean causados por su conducta culpable (dolosa o negligente), en particular:

- Su uso ilícito de los Servicios
- Su incumplimiento culpable de las presentes Condiciones
- Su infracción de cualquier ley o de derechos de terceros
- Los archivos de los que crea instantáneas, que restaura, exporta o importa con AutoBrew

Esta obligación no se aplica cuando, y en la medida en que, usted no sea responsable del incumplimiento de que se trate, y no afecta ni reduce sus derechos legales imperativos como consumidor.

---

## 12. RESOLUCIÓN

### 12.1 Por usted

Usted puede dejar de utilizar los Servicios en cualquier momento desinstalando AutoBrew. Al eliminar AutoBrew, su carpeta `~/Library/Application Support/AutoBrew/`, la carpeta `AutoBrew/Snapshots/` de una ubicación externa de instantáneas que haya elegido y su archivo de ajustes `~/Library/Preferences/za.co.digitalfreedom.AutoBrew.plist`, se eliminan los datos que conserva AutoBrew; la Política de privacidad, Sección 3.6, enumera todas las ubicaciones.

### 12.2 Por el Prestador

El Prestador podrá suspender o poner fin a su acceso por causa justificada, incluido un incumplimiento grave de las presentes Condiciones, el uso indebido de los Servicios o cuando así lo exija la ley, un tribunal o una autoridad, o un operador de plataforma. Un incumplimiento grave puede dar lugar a la resolución inmediata. Cuando el Prestador resuelva sin causa, avisará con una antelación razonable cuando la ley así lo exija. Los derechos legales imperativos de resolución de usted y del Prestador no se ven afectados. Los derechos que usted tenga en virtud de la Licencia MIT no se ven afectados.

### 12.3 Efectos de la resolución

Tras la resolución:

- Cesa su derecho a utilizar los Servicios, salvo en lo que permita la Licencia MIT
- Las disposiciones que por su naturaleza deban subsistir seguirán en vigor (incluidas las limitaciones de responsabilidad, la indemnización y la ley aplicable)

---

## 13. LEY APLICABLE Y RESOLUCIÓN DE LITIGIOS

### 13.1 Ley aplicable

Las presentes Condiciones se rigen por las leyes del Estado de Wyoming, Estados Unidos de América, con exclusión de sus normas de conflicto de leyes y de la Convención de las Naciones Unidas sobre los Contratos de Compraventa Internacional de Mercaderías. Si usted es consumidor, esta elección de ley no le priva de la protección que le otorgan las disposiciones imperativas de la ley de su país de residencia habitual (art. 6(2) del Reglamento Roma I y normas equivalentes).

### 13.2 Jurisdicción

Para los usuarios que no sean consumidores, los tribunales del condado de Sheridan, Wyoming, Estados Unidos, tienen competencia exclusiva. Los consumidores pueden interponer acciones ante los tribunales de su país de residencia habitual, y el Prestador solo puede demandarlos ante dichos tribunales.

### 13.3 Litigios de consumo (UE)

La plataforma de resolución de litigios en línea de la Comisión Europea dejó de funcionar el 20 de julio de 2025 tras la derogación del Reglamento (UE) n.º 524/2013 por el Reglamento (UE) 2024/3228. Los consumidores pueden dirigirse directamente al Prestador en hello@digitalfreedom.co.za. El Prestador no está obligado ni dispuesto a participar en procedimientos de resolución de litigios ante una entidad de arbitraje de consumo, salvo que la ley lo exija.

---

## 14. DISPOSICIONES REGIONALES

### 14.1 Unión Europea y EEE

**Se aplica a:** consumidores con residencia habitual en la UE o en el EEE (incluidos Noruega, Islandia y Liechtenstein).

**Quién suministra AutoBrew.** AutoBrew lo suministra gratuitamente y de forma directa el Prestador. No interviene ninguna tienda de aplicaciones y no hay compra.

**Desistimiento.** Las disposiciones sobre desistimiento del § 7 se refieren a contenidos digitales de pago; mientras AutoBrew sea gratuito, carecen de objeto. La información sobre el desistimiento para cualquier futura oferta de pago se facilitará con dicha oferta.

**Conformidad y actualizaciones.** La Directiva (UE) 2019/770 rige el suministro del contenido y del servicio digitales entre usted y el Prestador. Los requisitos de conformidad de los arts. 6 a 8 y la obligación de actualización del art. 8(2) son imperativos conforme al art. 22 y nada de lo dispuesto en las presentes Condiciones los excluye; véase la Política de soporte y actualizaciones (Ajustes → Legal → Política de soporte y actualizaciones).

**Para los consumidores de la UE/EEE no se aplica lo siguiente:**

- ninguna exclusión o limitación de responsabilidad que vaya más allá de las excepciones imperativas indicadas en el § 10;
- ninguna modificación del Servicio que vaya más allá de lo que el § 2.2 permite respecto de usted;
- ninguna aceptación presunta de condiciones modificadas por el mero silencio o el uso continuado;
- la renovación automática de un plazo anual por otro año completo;
- ninguna elección de ley que desplace las protecciones imperativas de su residencia habitual (art. 6(2) Roma I);
- ninguna cláusula que haga vinculante la versión inglesa cuando la ley de su Estado miembro exija el idioma local (el § 16.8 establece la regla sobre el idioma que prevalece).

**Particularidades nacionales.**

- **Alemania:** las obligaciones de aviso legal conforme al § 5 DDG y al § 18(2) MStV se cumplen en el Aviso legal (en AutoBrew, en Ajustes → Legal → Aviso legal). El § 308 n.º 5 y el § 309 n.º 9 BGB se aplican a las presentes Condiciones como condiciones con consumidores. El botón de resolución conforme al § 312k BGB se refiere a contratos que los consumidores pueden celebrar a través de un sitio web; actualmente, el Prestador no celebra ninguno de esa forma para AutoBrew.
- **Francia:** la información al consumidor se facilita en francés; para un consumidor residente en Francia prevalece la versión francesa (Loi Toubon; § 16.8).
- **Bélgica, Polonia:** requisitos de idioma local comparables a la regla francesa; se aplica el § 16.8.
- **Italia, España, Austria:** sobre la edad de consentimiento digital (14 años), véase la Política de privacidad.

### 14.2 Estados Unidos

- Cuando la legislación estatal lo prohíba, no se aplicarán las limitaciones de responsabilidad o de garantías

### 14.3 Reino Unido

- Se aplican las protecciones de la Consumer Rights Act 2015
- No se excluye la responsabilidad por muerte o lesiones personales causadas por negligencia

### 14.4 Canadá

- La legislación provincial de protección de los consumidores puede prevalecer sobre determinadas disposiciones
- Para los residentes en Quebec, prevalece la versión francesa cuando la ley de Quebec así lo exija (§ 16.8)

### 14.5 Australia y Nueva Zelanda

<!-- verbatim: ACL-prescribed-form | no-translate -->
> Our goods and services come with guarantees that cannot be excluded under the Australian Consumer Law. For major failures with the service, you are entitled:
>
> - to cancel your service contract with us; and
> - to a refund for the unused portion, or to compensation for its reduced value.
>
> You are also entitled to choose a refund or replacement for major failures with goods. If a failure with the goods or a service does not amount to a major failure, you are entitled to have the failure rectified in a reasonable time. If this is not done you are entitled to a refund for the goods and to cancel the contract for the service and obtain a refund of any unused portion. You are also entitled to be compensated for any other reasonably foreseeable loss or damage from a failure in the goods or service.
<!-- /verbatim -->

El aviso anterior matiza los §§ 9 y 10 de las presentes Condiciones y prevalece sobre ellos.

**Las garantías.** Para los productos y servicios digitales suministrados a un consumidor, la Australian Consumer Law garantiza una calidad aceptable (s. 54), la idoneidad para cualquier finalidad comunicada (s. 55), la correspondencia con la descripción (s. 56), la debida diligencia y competencia (s. 60) y la idoneidad de los servicios para la finalidad especificada (s. 61); la New Zealand Consumer Guarantees Act 1993 establece los equivalentes (ss. 6, 8, 9, 28, 29). Cuando un fallo es **grave** (major failure), es usted quien elige entre reembolso y sustitución, no el proveedor. Cuando no es grave, el proveedor puede repararlo en un plazo razonable. La sección 64 de la ACL declara nulo cualquier intento de excluir, restringir o modificar estas garantías; la s. 43 de la CGA hace lo mismo en Nueva Zelanda.

**Quién las debe.** El proveedor es el **Prestador**: AutoBrew lo suministra directamente DigitalFreedom Global LLC, sin que ninguna tienda actúe como vendedora o agente, y las garantías, los remedios por fallos graves y el aviso anterior los debe directamente el Prestador. La vía es el contacto de soporte (§ 16).

### 14.6 Turquía

AutoBrew lo suministra gratuitamente y de forma directa el Prestador; ninguna tienda actúa como vendedora. Si se introdujera una oferta de pago, las obligaciones de información precontractual y de desistimiento en 14 días conforme a la Ley de protección de los consumidores (n.º 6502) y al Reglamento sobre contratos a distancia recaerían sobre el Prestador. Los litigios de consumo por debajo del umbral legal deben plantearse ante un **Comité de Arbitraje de Consumo** (Consumer Arbitration Committee) antes de acudir a un tribunal; esto es obligatorio, nada de lo dispuesto en las presentes Condiciones lo excluye, y matiza la expresión "salvo que la ley lo exija" del § 13.3.

### 14.7 Japón

Para las ventas a consumidores en Japón, la Ley sobre transacciones comerciales especificadas (特定商取引法) exige que el nombre, la dirección y los datos de contacto del vendedor, el precio y las condiciones de cancelación estén fácilmente disponibles. AutoBrew lo suministra directamente el Prestador, por lo que estas obligaciones de información recaen sobre el Prestador y se cumplen en el Aviso legal (en AutoBrew, en Ajustes → Legal → Aviso legal).

### 14.8 Otras jurisdicciones

- Cuando una norma local imperativa restrinja alguna disposición, dicha disposición se aplicará solo en la medida permitida
- Las protecciones imperativas de los consumidores de su residencia habitual no se ven afectadas en ningún lugar

## 15. FUERZA MAYOR

Ninguna de las partes será responsable del retraso o del incumplimiento de cualquier obligación derivada de las presentes Condiciones en la medida en que el retraso o el incumplimiento se deban a acontecimientos que escapen a un control razonable, incluidos, entre otros, fenómenos naturales, guerras, disturbios civiles, terrorismo, ciberataques, actuaciones gubernamentales, pandemias, incendios, inundaciones, cortes prolongados de electricidad o de telecomunicaciones, o fallos de la infraestructura de los subencargados del tratamiento de los que se depende. La parte afectada lo notificará a la otra sin demora indebida y hará esfuerzos razonables para mitigarlo.

Esta Sección no afecta a la obligación de pagar importes ya vencidos ni a ningún derecho imperativo de protección de los consumidores del país de residencia del usuario.

---

## 16. DISPOSICIONES GENERALES

### 16.1 Divisibilidad

Si alguna disposición se declara inválida, las disposiciones restantes seguirán plenamente en vigor.

### 16.2 Renuncia

No exigir el cumplimiento de una disposición no constituye una renuncia.

### 16.3 Cesión

El Prestador podrá ceder las presentes Condiciones en relación con una fusión, una adquisición, una reorganización societaria o una venta de activos. Los usuarios serán informados con al menos 30 días de antelación de cualquier cambio de la entidad contratante y, cuando la ley lo exija, se recabará un nuevo consentimiento. Usted no podrá ceder sin consentimiento previo por escrito.

### 16.4 Acuerdo íntegro

Las presentes Condiciones, junto con la Política de privacidad, el CLUF, el Resumen del marco jurídico, la Política de soporte y actualizaciones, la Política de divulgación de vulnerabilidades, el Aviso sobre marcas y las Licencias de código abierto que se distribuyen con AutoBrew (Ajustes → Legal), y la Licencia MIT bajo la que se publica el código fuente de AutoBrew, constituyen el acuerdo íntegro entre usted y el Prestador.

### 16.5 Modificaciones

El Prestador podrá actualizar las presentes Condiciones. Los cambios significativos se notifican con al menos 30 días de antelación a través de los Servicios o por correo electrónico y, cuando así lo exija la legislación aplicable de protección de los consumidores, solo surten efecto tras una nueva aceptación. El uso continuado tras cambios no significativos constituye aceptación.

### 16.6 Plazo de prescripción

Las reclamaciones derivadas de las presentes Condiciones están sujetas a los plazos de prescripción legales de la ley aplicable. Esto no afecta a ningún plazo de prescripción imperativo del país de residencia del usuario.

### 16.7 Notificaciones

Las notificaciones al Prestador deben enviarse a `hello@digitalfreedom.co.za` (general) o a `data-protection@digitalfreedom.co.za` (privacidad / DSGVO). Las notificaciones a usted pueden realizarse en AutoBrew o en sus notas de versión, o por correo electrónico cuando usted se haya puesto en contacto con el Prestador por correo electrónico.

### 16.8 Idioma

Las presentes Condiciones se publican en varios idiomas. **Para un consumidor, prevalece la versión en una lengua oficial de su lugar de residencia habitual**, cuando exista dicha versión. La versión inglesa prevalece para los clientes empresariales y para los idiomas en los que no exista versión. Esto es lo contrario de la cláusula habitual y es deliberado: una cláusula que haga vinculante el inglés no se sostiene en Francia, Bélgica, Polonia, Italia, Quebec o Turquía, y declarar no vinculantes las traducciones desvirtuaría el motivo por el que se elaboran.

---

Soporte: support@digitalfreedom.co.za · https://support.apps.digitalfreedom.co.za

(c) 2025-2026 DigitalFreedom Global LLC. Todos los derechos reservados.
