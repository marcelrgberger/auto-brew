<!-- doc-id: CRA_USER_INFORMATION | lang: en | area: apps/documents | version: 1.0.0 | valid-from: 2026-09-01 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-06-01 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/apps/documents/CRA_USER_INFORMATION.en.md | SBOM: none published (no SBOM found in the repository); portfolio transport-encryption sentence replaced by AutoBrew facts (§ 4); placeholders: APP_NAME=AutoBrew, APP_VERSION=2.5.4, BUNDLE_ID=za.co.digitalfreedom.AutoBrew, SUPPORT_END=October 2031 for 2.5.4 (GitHub release 2026-10-15) and five years from release for later versions, APP_DOMAIN: no product domain (§ 6 states that the declaration is not yet issued), AUTH_METHOD=none, storage=on the Mac; adaptations: direct distribution and Sparkle updates (§ 3, § 8), generator instruction in the header replaced by a user-facing statement, sibling links replaced by document names | translated-from: en -->
# INFORMATIONS DE SÉCURITÉ RELATIVES À CE PRODUIT

## Informations et instructions destinées à l'utilisateur — annexe II du règlement (UE) 2024/2847 (Cyber Resilience Act, règlement sur la cyberrésilience)

**Produit :** AutoBrew, version 2.5.4 et ultérieures
**Applicable à partir du :** l'annexe II du Cyber Resilience Act s'applique aux produits mis sur le marché de l'UE à partir du
**11 décembre 2027**, et plus tôt pour tout produit existant faisant l'objet d'une modification substantielle.
Ces informations sont fournies pour AutoBrew avant cette date.

---

## 1. Fabricant

DigitalFreedom — une marque de DigitalFreedom Global LLC
30 N Gould St, Ste N, Sheridan, WY 82801, United States
Point de contact unique : hello@digitalfreedom.co.za

## 2. Où signaler une vulnérabilité

Signalements de sécurité : <https://security.digitalfreedom.co.za> ou `security@digitalfreedom.co.za`.
La procédure complète, y compris la clause de protection (safe harbour), figure dans la Politique de divulgation coordonnée des vulnérabilités (Réglages → Mentions légales → Divulgation des vulnérabilités) ;
version lisible par machine : https://digitalfreedom.co.za/.well-known/security.txt.

## 3. Identification du produit

AutoBrew — `za.co.digitalfreedom.AutoBrew` — une application macOS (macOS 14 ou ultérieur), distribuée directement sous forme de téléchargement notarié depuis GitHub Releases (https://github.com/marcelrgberger/auto-brew/releases) et via le tap Homebrew `marcelrgberger/homebrew-tap`.
La version installée est affichée dans les réglages de l'application, dans la section À propos, au-dessus de la rubrique des mentions légales.

## 4. Destination et propriétés essentielles de cybersécurité

AutoBrew maintient à jour les paquets Homebrew d'un Mac selon la politique de mise à jour définie par l'utilisateur, fournit une interface graphique permettant de parcourir, installer, mettre à niveau et supprimer des casks Homebrew, et crée, restaure et migre des instantanés des données utilisateur des applications. Propriétés de sécurité : aucun SDK publicitaire et aucun identifiant publicitaire ; notifications locales uniquement ;
authentification : aucune — l'application fonctionne exclusivement en local ; stockage des données : uniquement sur l'appareil.

Pour AutoBrew en particulier : les connexions qu'AutoBrew ouvre lui-même utilisent HTTPS ; les adresses de téléchargement des paquets installés par Homebrew sont définies par leurs éditeurs et par le projet Homebrew. Chaque version est signée avec un certificat Apple Developer ID, notariée par Apple et compilée avec le Hardened Runtime. Les mises à jour fournies par le programme de mise à jour intégré (Sparkle) sont vérifiées au moyen d'une signature EdDSA (Ed25519) avant leur installation. AutoBrew stocke ses données sur le Mac, ou à l'emplacement de stockage des instantanés choisi par l'utilisateur ; il n'envoie aucune donnée au fabricant.

## 5. Circonstances connues ou prévisibles de risque important pour la cybersécurité

- **AutoBrew fonctionne en dehors de l'App Sandbox**, car il doit exécuter `brew`, `ditto` et d'autres outils système. Il agit avec les droits de l'utilisateur connecté.
- **Les logiciels installés ou mis à niveau via Homebrew** sont publiés par des tiers et s'exécutent avec les droits de l'utilisateur. Lorsque les mises à niveau automatiques sont activées, les nouvelles versions sont installées selon la politique de mise à jour définie par l'utilisateur, sans confirmation distincte pour chaque mise à jour de la catégorie « installer automatiquement ».
- **Les instantanés contiennent des copies de données d'applications**, qui peuvent inclure des identifiants de connexion, des jetons ou d'autres informations sensibles qu'une application conserve dans ses dossiers de données utilisateur. Les instantanés et les fichiers d'instantanés exportés ne sont pas chiffrés par AutoBrew ; toute personne ayant accès à l'emplacement des instantanés, à un disque externe utilisé à cet effet ou à un fichier exporté peut les lire. Les instantanés automatiques avant les mises à niveau sont activés par défaut (Réglages → Instantanés).
- **L'installation de Homebrew** depuis AutoBrew exécute le script d'installation officiel de Homebrew téléchargé depuis GitHub.

Aucune de ces circonstances ne constitue une vulnérabilité connue. Les circonstances découvertes ultérieurement sont traitées au moyen de mises à jour de sécurité et, lorsqu'elles atteignent les seuils de l'article 14, notifiées conformément aux exigences.

## 6. Déclaration UE de conformité

La déclaration UE de conformité est exigée à partir du 11 décembre 2027 et n'a pas encore été établie pour AutoBrew. Une fois établie, elle sera disponible sur demande à l'adresse hello@digitalfreedom.co.za et son emplacement sera indiqué ici.

## 7. Assistance technique et période d'assistance

Les vulnérabilités de sécurité sont traitées et des mises à jour de sécurité sont fournies **au moins jusqu'en octobre 2031 pour la version 2.5.4** (publiée sur GitHub Releases le 15 octobre 2026), et, pour chaque version ultérieure, au moins jusqu'au même mois cinq ans après la publication de cette version sur GitHub Releases.
L'engagement général et ce que recouvre l'« assistance » figurent dans la Politique d'assistance et de mises à jour (Réglages → Mentions légales → Politique d'assistance et de mises à jour). Demandes d'assistance :
<https://support.apps.digitalfreedom.co.za>.

## 8. Utilisation sécurisée pendant la durée de vie du produit

- **Installation et première utilisation :** installez uniquement depuis GitHub Releases à l'adresse https://github.com/marcelrgberger/auto-brew/releases ou via le tap Homebrew `marcelrgberger/homebrew-tap` ; macOS vérifie la signature Developer ID et la notarisation lors de la première ouverture de l'application. Aucune configuration n'est nécessaire pour un paramétrage sécurisé par défaut — l'application ne comporte aucun flux de données facultatif vers le fabricant.
- **Les mises à jour de sécurité** sont fournies via le programme de mise à jour intégré d'AutoBrew (Réglages → Mises à jour → Rechercher les mises à jour), via le tap Homebrew ou sous forme de nouveau téléchargement depuis GitHub Releases. Laissez activée la recherche automatique de mises à jour ; si vous la désactivez, recherchez régulièrement les mises à jour — une version obsolète ne reçoit plus de correctifs.
- **Modifications ayant une incidence sur la sécurité :** l'octroi d'autorisations du système d'exploitation étend ce à quoi l'application peut accéder ; AutoBrew demande l'autorisation d'afficher des notifications, et toute autorisation peut être révoquée à tout moment dans les Réglages Système. Le choix d'un emplacement de stockage externe pour les instantanés, l'activation de l'installation automatique pour une catégorie de paquets et l'exécution de commandes préalables aux instantanés propres à un paquet étendent ce qu'AutoBrew fait en votre nom.
- **Mise hors service :** la désinstallation supprime l'application. Pour supprimer ses données locales, supprimez les dossiers énumérés dans la Politique de confidentialité, section 3.6, y compris un emplacement externe d'instantanés que vous avez choisi et tout fichier d'instantané exporté. AutoBrew ne comporte aucun compte et ne conserve aucune donnée sur les serveurs du fabricant.

## 9. Nomenclature des logiciels (SBOM)

Aucune SBOM n'est publiée pour AutoBrew. Les composants tiers et leurs licences sont énumérés dans le document Licences open source (Réglages → Mentions légales → Licences open source).
