<!-- doc-id: TERMS_OF_SERVICE | lang: en | area: shared | version: 2.0.1 | valid-from: 2026-10-13 | supersedes: TERMS_OF_SERVICE 2.0.0 (telephone number removed from § 14.7), 1.x; absorbs EU_CONSUMER_ANNEX, ANZ_CONSUMER_ANNEX (consumer parts, 1.0.0) | owner: Marcel R. G. Berger | next-review: 2027-08-31 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/shared/TERMS_OF_SERVICE.en.md | adaptations: direct distribution instead of app stores (§ 1.1.1, § 14.1, § 14.5-14.7), AutoBrew description, Homebrew and updates (§ 2.1, § 2.4, § 2.5), no accounts (§ 3), no user content sent to the Provider (§ 4), no shared resource (§ 5), free of charge (§ 7), MIT License (§ 5, § 6.1, § 12.2), sibling links replaced by in-app document names, translation count removed (§ 16.8) | translated-from: en -->
# CONDITIONS D'UTILISATION

## Conditions générales

**Application :** AutoBrew

**Date d'entrée en vigueur :** 15 octobre 2026

**Prestataire :**
DigitalFreedom
Une marque de DigitalFreedom Global LLC
30 N Gould St, Ste N
Sheridan, WY 82801
United States
Contact : hello@digitalfreedom.co.za
Site web : https://digitalfreedom.co.za

---

## 1. CHAMP D'APPLICATION ET ACCEPTATION

### 1.1 Contrat

Les présentes Conditions d'utilisation (les « Conditions ») régissent votre accès à l'application AutoBrew et aux services associés, tels que l'assistance (les « Services »), et leur utilisation, fournis sous la marque **DigitalFreedom** par DigitalFreedom Global LLC (le « Prestataire »).

### 1.1.1 Portée mondiale

AutoBrew est distribué directement par le Prestataire — sous forme de téléchargement notarié depuis GitHub Releases et via le tap Homebrew `marcelrgberger/homebrew-tap` — et non via l'Apple App Store ou le Google Play Store. Il peut être téléchargé dans tout pays depuis lequel ces canaux sont accessibles. Les présentes Conditions s'appliquent dans le monde entier à tous les utilisateurs des Services, quel que soit le pays d'accès ou d'utilisation. Le Prestataire adopte le règlement général sur la protection des données de l'Union européenne (RGPD) et le droit de l'UE connexe comme norme de référence et l'applique comme socle minimal mondial ; les droits impératifs en matière de protection des consommateurs et les autres droits légaux conférés par le pays de résidence de l'utilisateur ne sont pas affectés et prévalent dès lors qu'ils sont plus protecteurs.

### 1.2 Acceptation

En accédant aux Services ou en les utilisant, vous acceptez d'être lié par les présentes Conditions. Si vous ne les acceptez pas, vous ne devez pas utiliser les Services.

### 1.3 Conditions d'éligibilité

Pour conclure un contrat avec nous, vous devez disposer de la capacité juridique requise à cet effet par le droit de votre lieu de résidence — en règle générale 18 ans, et 19 ans en Corée du Sud. Les mineurs ne peuvent utiliser les Services qu'avec la participation d'un parent ou d'un tuteur qui accepte les présentes Conditions en leur nom.

Il s'agit d'une question distincte de l'âge à partir duquel vous pouvez consentir au traitement de vos données à caractère personnel, qui est fixé entre 13 et 16 ans selon l'État membre et qui est traité dans la Politique de confidentialité. Aucun de ces deux seuils ne détermine l'autre : le § 110 BGB, qui permet à un mineur de conclure certains contrats au moyen de ses propres ressources, ne couvre pas une obligation continue telle qu'un abonnement.

### 1.4 Utilisation professionnelle

Si vous utilisez les Services pour le compte d'une organisation, vous déclarez être habilité à engager cette organisation au titre des présentes Conditions.

---

## 2. SERVICES

### 2.1 Description

AutoBrew est une application macOS de barre des menus qui maintient à jour les paquets Homebrew selon la politique de mise à jour que vous définissez, fournit une interface graphique permettant de parcourir, installer, mettre à niveau et supprimer des casks Homebrew, et crée, restaure et migre des instantanés des données utilisateur des applications sur votre Mac. AutoBrew est :

- **Open source** sous licence MIT — code source à l'adresse https://github.com/marcelrgberger/auto-brew
- **Gratuit** — aucun achat intégré, aucun abonnement, aucune offre payante
- **Local** — il fonctionne sur votre Mac et ne nécessite ni compte ni service backend du Prestataire

### 2.2 Modifications

Le Prestataire se réserve le droit de modifier, de suspendre ou d'interrompre tout Service. **Pour les consommateurs de l'UE et de l'EEE, ce droit est limité :** au-delà de ce qui est nécessaire au maintien de la conformité du Service, le Service n'est modifié que pour un motif valable indiqué ici — adaptation à un nouvel environnement technique, à des exigences de plateforme modifiées, à des exigences légales, ou abandon d'un service tiers dont dépend la fonctionnalité — et toute modification ayant une incidence plus que mineure sur votre accès ou votre utilisation vous est notifiée à l'avance sur un support durable, en même temps que votre droit de résilier sans frais dans un délai de 30 jours si la modification vous est préjudiciable (article 19 de la directive (UE) 2019/770 / § 327r BGB). Les modifications importantes sont communiquées à tous dans la mesure du possible.

### 2.3 Disponibilité

Les Services sont fournis « selon leur disponibilité ». Le Prestataire ne garantit pas un accès ou une disponibilité ininterrompus.

### 2.4 Homebrew

AutoBrew nécessite une installation Homebrew fonctionnelle et exécute la commande `brew` sur votre Mac. Le Prestataire n'est pas affilié au projet Homebrew et ne contrôle ni les paquets disponibles, ni la date de publication des versions, ni ce que les éditeurs des différents paquets font de leurs programmes d'installation. L'installation, la mise à niveau ou la suppression d'un paquet au moyen d'AutoBrew est une opération de Homebrew et du paquet concerné (voir les sections 8 à 10).

### 2.5 Mises à jour

AutoBrew se met à jour au moyen du framework Sparkle à partir de l'appcast d'AutoBrew publié sur GitHub. Chaque mise à jour est signée avec une clé EdDSA (Ed25519) et vérifiée avant son installation. Vous pouvez également effectuer la mise à jour via le tap Homebrew ou en téléchargeant manuellement une version plus récente.

---

## 3. COMPTES

AutoBrew ne comporte aucun compte. Aucune inscription n'est requise et le Prestataire ne conserve rien pour vous dans le cadre d'un compte ; les sections 3.1 à 3.3 des conditions générales (inscription, sécurité des identifiants, suspension de compte) ne s'appliquent donc pas.

---

## 4. CONTENU DE L'UTILISATEUR

AutoBrew n'envoie au Prestataire rien de ce que vous créez ou stockez avec lui : les réglages, les politiques de mise à jour, les collections et les instantanés restent sur votre Mac. Vous demeurez seul responsable des fichiers dont vous créez un instantané, que vous restaurez, exportez ou importez, ainsi que de votre droit de le faire. Ce que vous envoyez au Prestataire dans une demande d'assistance n'est utilisé que pour y répondre, comme décrit dans la Politique de confidentialité.

---

## 5. UTILISATION ACCEPTABLE

Vous vous engagez à ne pas :

- Enfreindre une loi ou une réglementation applicable
- Porter atteinte à la propriété intellectuelle ou à d'autres droits de tiers
- Transmettre des logiciels malveillants, du spam ou des contenus préjudiciables
- Tenter d'accéder sans autorisation aux Services ou aux systèmes associés
- Perturber le fonctionnement ou la sécurité des Services
- Utiliser les Services à des fins frauduleuses ou trompeuses
- Redistribuer AutoBrew autrement que conformément à la licence MIT, présenter un fork comme la distribution officielle d'AutoBrew, ou utiliser les marques AutoBrew ou DigitalFreedom en violation du § 6.2

---

## 6. PROPRIÉTÉ INTELLECTUELLE

### 6.1 Propriété intellectuelle du Prestataire

Les Services, y compris les logiciels, le design, les logos et la documentation, sont protégés par les lois relatives à la propriété intellectuelle. Le code source d'AutoBrew est publié sous la licence MIT, qui confère les droits qui y sont énoncés ; tous les droits qui ne sont pas expressément concédés restent la propriété du Prestataire.

### 6.2 Marques

Les marques et noms commerciaux du Prestataire ne peuvent être utilisés sans son consentement écrit préalable. **AutoBrew** et **DigitalFreedom** sont des marques de DigitalFreedom Global LLC ; la licence MIT ne confère aucun droit sur celles-ci. Les forks et œuvres dérivées peuvent faire référence à AutoBrew de manière descriptive (par exemple « fork of AutoBrew »), mais ne peuvent utiliser ces marques comme nom de produit, pour un produit ou service payant concurrent, ou d'une manière suggérant une recommandation du Prestataire. Les détails figurent dans l'Avertissement relatif aux marques fourni avec AutoBrew, section 4.

### 6.3 Retours

Tout retour ou toute suggestion que vous fournissez peut être utilisé par le Prestataire sans obligation à votre égard.

---

## 7. PAIEMENTS ET ABONNEMENTS

AutoBrew est gratuit. Il ne comporte ni achats intégrés ni abonnements ; les dispositions des conditions générales relatives aux prix, au traitement des paiements, aux abonnements, à la California Automatic Renewal Law, aux remboursements et au droit de rétractation de l'UE pour les contenus numériques payants sont donc sans objet tant qu'AutoBrew est gratuit.

Le lien **Sponsor** dans AutoBrew mène à GitHub Sponsors et est entièrement facultatif. Une contribution constitue un don, est traitée par GitHub selon ses propres conditions et ne confère aucun droit à des fonctionnalités ou à une assistance.

Le Prestataire peut introduire, dans des versions futures, des fonctionnalités payantes facultatives, des éditions payantes ou des services complémentaires payants. Les conditions de toute offre de ce type, y compris les informations précontractuelles qu'elle exige à l'égard des consommateurs, seront publiées avant qu'elle ne soit proposée ; votre droit de continuer à utiliser une version gratuite que vous avez déjà installée n'est pas affecté.

---

## 8. SERVICES TIERS

### 8.1 Intégration

Les Services peuvent s'intégrer à des services tiers ou contenir des liens vers ceux-ci. Le Prestataire ne cautionne ni ne contrôle ces services.

### 8.2 Conditions

Votre utilisation de services tiers est soumise à leurs conditions et politiques de confidentialité respectives.

### 8.3 Responsabilité

Le Prestataire n'est pas responsable des dommages résultant de votre utilisation de services tiers.

---

## 9. EXCLUSION DE GARANTIES

DANS TOUTE LA MESURE PERMISE PAR LA LOI :

- Les Services sont fournis « EN L'ÉTAT » et « SELON LEUR DISPONIBILITÉ »
- Le Prestataire exclut toute garantie, expresse ou implicite
- Aucune garantie n'est donnée quant à l'exactitude, l'exhaustivité, la fiabilité ou l'adéquation à un usage particulier
- Aucune garantie n'est donnée quant au caractère ininterrompu, sécurisé ou exempt d'erreurs des Services

Aucune disposition de la présente section n'exclut ni ne limite une garantie ou une responsabilité qui ne peut être exclue ou limitée en vertu du droit impératif applicable, y compris les droits légaux impératifs de garantie des consommateurs. **Pour les consommateurs d'Australie et de Nouvelle-Zélande, le § 14.5 s'applique et prévaut sur la présente section.**

---

## 10. LIMITATION DE RESPONSABILITÉ

DANS TOUTE LA MESURE PERMISE PAR LA LOI :

- Le Prestataire ne saurait être tenu responsable des dommages indirects, accessoires, spéciaux, consécutifs ou punitifs
- Le Prestataire ne saurait être tenu responsable de la perte de données, de bénéfices, de chiffre d'affaires ou d'opportunités commerciales
- La responsabilité totale cumulée ne pourra excéder le plus élevé des deux montants suivants : (a) le montant que vous avez payé au cours des 12 mois précédant la réclamation, ou (b) 100 EUR

**Exceptions impératives.** Les exclusions et limitations ci-dessus ne s'appliquent **pas** aux cas suivants, pour lesquels le Prestataire demeure pleinement responsable : (a) les dommages résultant d'une faute intentionnelle ou d'une négligence grave ; (b) les atteintes à la vie, à l'intégrité physique ou à la santé ; (c) la responsabilité au titre du droit impératif de la responsabilité du fait des produits (y compris la loi allemande sur la responsabilité du fait des produits / Produkthaftungsgesetz) ; (d) la violation fautive d'une obligation contractuelle essentielle (obligation cardinale / *Kardinalpflicht*) — dans ce cas, la responsabilité pour négligence légère est limitée au dommage prévisible et typique du contrat ; et (e) toute autre responsabilité qui ne peut être limitée ou exclue en vertu du droit impératif applicable. Les droits légaux impératifs des consommateurs ne sont pas affectés. **Pour les consommateurs d'Australie et de Nouvelle-Zélande, le § 14.5 s'applique et prévaut sur la présente section.**

---

## 11. INDEMNISATION

Dans la mesure permise par le droit applicable, vous acceptez d'indemniser et de garantir le Prestataire contre les réclamations de tiers, dommages, pertes et frais (y compris des honoraires d'avocat raisonnables) dans la mesure où ils sont causés par votre comportement fautif (intentionnel ou négligent), en particulier :

- Votre utilisation illicite des Services
- Votre violation fautive des présentes Conditions
- Votre violation d'une loi ou de droits de tiers
- Les fichiers dont vous créez un instantané, que vous restaurez, exportez ou importez avec AutoBrew

Cette obligation ne s'applique pas lorsque, et dans la mesure où, vous n'êtes pas responsable du manquement concerné, et elle n'affecte ni ne réduit vos droits légaux impératifs en tant que consommateur.

---

## 12. RÉSILIATION

### 12.1 Par vous

Vous pouvez cesser d'utiliser les Services à tout moment en désinstallant AutoBrew. La suppression d'AutoBrew, de son dossier `~/Library/Application Support/AutoBrew/`, du dossier `AutoBrew/Snapshots/` situé dans un emplacement externe d'instantanés que vous avez choisi et de son fichier de réglages `~/Library/Preferences/za.co.digitalfreedom.AutoBrew.plist` supprime les données conservées par AutoBrew ; la Politique de confidentialité, section 3.6, énumère tous les emplacements.

### 12.2 Par le Prestataire

Le Prestataire peut suspendre ou résilier votre accès pour un motif légitime — notamment en cas de violation substantielle des présentes Conditions, d'utilisation abusive des Services, ou lorsque la loi, une juridiction, une autorité ou un exploitant de plateforme l'exige. Une violation substantielle peut entraîner une résiliation immédiate. Lorsque le Prestataire résilie sans motif, il respecte un préavis raisonnable lorsque la loi l'exige. Vos droits de résiliation légaux impératifs et ceux du Prestataire ne sont pas affectés. Les droits que vous détenez au titre de la licence MIT ne sont pas affectés.

### 12.3 Effets de la résiliation

En cas de résiliation :

- Votre droit d'utiliser les Services prend fin, sauf dans la mesure permise par la licence MIT
- Les dispositions qui, par leur nature, doivent survivre restent en vigueur (notamment les limitations de responsabilité, l'indemnisation et le droit applicable)

---

## 13. DROIT APPLICABLE ET RÈGLEMENT DES LITIGES

### 13.1 Droit applicable

Les présentes Conditions sont régies par le droit de l'État du Wyoming, États-Unis d'Amérique, à l'exclusion de ses règles de conflit de lois et de la Convention des Nations unies sur les contrats de vente internationale de marchandises. Si vous êtes un consommateur, ce choix de loi ne peut avoir pour effet de vous priver de la protection que vous assurent les dispositions impératives du droit de votre pays de résidence habituelle (article 6, paragraphe 2, du règlement Rome I et règles équivalentes).

### 13.2 Juridiction compétente

Pour les utilisateurs qui ne sont pas des consommateurs, les tribunaux du comté de Sheridan, Wyoming, États-Unis, sont exclusivement compétents. Les consommateurs peuvent agir devant les tribunaux de leur pays de résidence habituelle et ne peuvent être assignés par le Prestataire que devant ces tribunaux.

### 13.3 Litiges de consommation (UE)

La plateforme de règlement en ligne des litiges de la Commission européenne a cessé de fonctionner le 20 juillet 2025, à la suite de l'abrogation du règlement (UE) n° 524/2013 par le règlement (UE) 2024/3228. Les consommateurs peuvent contacter directement le Prestataire à l'adresse hello@digitalfreedom.co.za. Le Prestataire n'est ni tenu ni disposé à participer à une procédure de règlement des litiges devant un organe de médiation de la consommation, sauf obligation légale.

---

## 14. DISPOSITIONS RÉGIONALES

### 14.1 Union européenne et EEE

**S'applique à :** les consommateurs ayant leur résidence habituelle dans l'UE ou dans l'EEE (y compris la Norvège, l'Islande et le Liechtenstein).

**Qui fournit AutoBrew.** AutoBrew est fourni gratuitement et directement par le Prestataire. Aucune boutique d'applications n'intervient et il n'y a pas d'achat.

**Rétractation.** Les dispositions relatives à la rétractation du § 7 concernent les contenus numériques payants ; tant qu'AutoBrew est gratuit, elles sont sans objet. Les informations relatives à la rétractation pour toute offre payante future seront fournies avec cette offre.

**Conformité et mises à jour.** La directive (UE) 2019/770 régit la fourniture du contenu et du service numériques entre vous et le Prestataire. Les exigences de conformité des articles 6 à 8 et l'obligation de mise à jour de l'article 8, paragraphe 2, sont impératives en vertu de l'article 22 et ne sont exclues par aucune disposition des présentes Conditions — voir la Politique d'assistance et de mises à jour (Réglages → Mentions légales → Politique d'assistance et de mises à jour).

**Pour les consommateurs de l'UE/EEE, ne s'appliquent pas :**

- toute exclusion ou limitation de responsabilité allant au-delà des exceptions impératives énoncées au § 10 ;
- toute modification du Service allant au-delà de ce que le § 2.2 permet à votre égard ;
- toute acceptation présumée de conditions modifiées du seul fait du silence ou de la poursuite de l'utilisation ;
- toute reconduction automatique d'une durée annuelle pour une nouvelle année entière ;
- tout choix de loi écartant les protections impératives de votre lieu de résidence habituelle (article 6, paragraphe 2, de Rome I) ;
- toute clause rendant la version anglaise contraignante lorsque le droit de votre État membre exige la langue locale (le § 16.8 énonce la règle relative à la langue faisant foi).

**Spécificités nationales.**

- **Allemagne :** les obligations relatives aux mentions légales au titre du § 5 DDG et du § 18, al. 2, MStV sont remplies dans les mentions de l'Éditeur (dans AutoBrew sous Réglages → Mentions légales → Éditeur). Les § 308, n° 5, et § 309, n° 9, BGB s'appliquent aux présentes Conditions en tant que conditions applicables aux consommateurs. Le bouton de résiliation prévu au § 312k BGB s'applique aux contrats que les consommateurs peuvent conclure par l'intermédiaire d'un site web ; le Prestataire n'en conclut actuellement aucun de cette manière pour AutoBrew.
- **France :** les informations destinées aux consommateurs sont fournies en français ; pour un consommateur résidant en France, la version française fait foi (loi Toubon ; § 16.8).
- **Belgique, Pologne :** exigences de langue locale comparables à la règle française ; le § 16.8 s'applique.
- **Italie, Espagne, Autriche :** pour l'âge du consentement numérique (14 ans), voir la Politique de confidentialité.

### 14.2 États-Unis

- Lorsque le droit d'un État l'interdit, les limitations de responsabilité ou de garanties ne s'appliquent pas

### 14.3 Royaume-Uni

- Les protections du Consumer Rights Act 2015 s'appliquent
- La responsabilité en cas de décès ou de dommage corporel causé par une négligence n'est pas exclue

### 14.4 Canada

- La législation provinciale en matière de protection des consommateurs peut prévaloir sur certaines dispositions
- Pour les résidents du Québec, la version française fait foi lorsque le droit québécois l'exige (§ 16.8)

### 14.5 Australie et Nouvelle-Zélande

<!-- verbatim: ACL-prescribed-form | no-translate -->
> Our goods and services come with guarantees that cannot be excluded under the Australian Consumer Law. For major failures with the service, you are entitled:
>
> - to cancel your service contract with us; and
> - to a refund for the unused portion, or to compensation for its reduced value.
>
> You are also entitled to choose a refund or replacement for major failures with goods. If a failure with the goods or a service does not amount to a major failure, you are entitled to have the failure rectified in a reasonable time. If this is not done you are entitled to a refund for the goods and to cancel the contract for the service and obtain a refund of any unused portion. You are also entitled to be compensated for any other reasonably foreseeable loss or damage from a failure in the goods or service.
<!-- /verbatim -->

L'avis ci-dessus nuance les §§ 9 et 10 des présentes Conditions et prévaut sur ceux-ci.

**Les garanties.** Pour les produits et services numériques fournis à un consommateur, l'Australian Consumer Law garantit la qualité acceptable (art. 54), l'adéquation à toute finalité communiquée (art. 55), la conformité à la description (art. 56), la diligence et la compétence requises (art. 60) et l'adéquation des services à la finalité spécifiée (art. 61) ; le Consumer Guarantees Act 1993 néo-zélandais prévoit les équivalents (art. 6, 8, 9, 28, 29). En cas de défaillance **majeure**, c'est vous qui choisissez entre le remboursement et le remplacement — et non le fournisseur. Lorsque la défaillance n'est pas majeure, le fournisseur peut y remédier dans un délai raisonnable. L'article 64 de l'ACL frappe de nullité toute tentative d'exclure, de restreindre ou de modifier ces garanties ; l'article 43 du CGA fait de même en Nouvelle-Zélande.

**Qui en est débiteur.** Le fournisseur est le **Prestataire** : AutoBrew est fourni directement par DigitalFreedom Global LLC, sans qu'un store agisse en qualité de vendeur ou de mandataire, et les garanties, les recours en cas de défaillance majeure et l'avis ci-dessus sont dus directement par le Prestataire. La voie à suivre est le contact d'assistance (§ 16).

### 14.6 Türkiye

AutoBrew est fourni gratuitement et directement par le Prestataire ; aucun store n'agit en qualité de vendeur. Si une offre payante venait à être introduite, les obligations d'information précontractuelle et de rétractation de 14 jours prévues par la loi sur la protection des consommateurs (n° 6502) et le règlement sur les contrats à distance incomberaient au Prestataire. Les litiges de consommation inférieurs au seuil légal doivent être portés devant un **comité d'arbitrage des consommateurs** (Consumer Arbitration Committee) avant toute saisine d'un tribunal ; cette procédure est obligatoire, aucune disposition des présentes Conditions n'y déroge, et elle précise la réserve « sauf obligation légale » du § 13.3.

### 14.7 Japon

Pour les ventes aux consommateurs au Japon, la loi sur les transactions commerciales spécifiées (特定商取引法) exige que le nom, l'adresse et les coordonnées du vendeur, le prix et les conditions d'annulation soient facilement accessibles. AutoBrew est fourni directement par le Prestataire ; ces obligations d'affichage incombent donc au Prestataire et sont remplies dans les mentions de l'Éditeur (dans AutoBrew sous Réglages → Mentions légales → Éditeur).

### 14.8 Autres juridictions

- Lorsque le droit impératif local restreint une disposition, celle-ci ne s'applique que dans la mesure permise
- Les protections impératives des consommateurs de votre lieu de résidence habituelle ne sont affectées nulle part

## 15. FORCE MAJEURE

Aucune des parties n'est responsable d'un retard ou d'un manquement dans l'exécution d'une obligation au titre des présentes Conditions dans la mesure où ce retard ou ce manquement est causé par des événements échappant à son contrôle raisonnable, notamment les catastrophes naturelles, la guerre, les troubles civils, le terrorisme, les cyberattaques, les mesures gouvernementales, les pandémies, les incendies, les inondations, les pannes prolongées d'électricité ou de télécommunications, ou la défaillance de l'infrastructure de sous-traitants en amont. La partie affectée en informe l'autre sans retard injustifié et met en œuvre des efforts raisonnables pour en atténuer les effets.

La présente section n'affecte ni l'obligation de payer les sommes déjà exigibles, ni aucun droit impératif de protection des consommateurs prévu par le pays de résidence de l'utilisateur.

---

## 16. DISPOSITIONS GÉNÉRALES

### 16.1 Divisibilité

Si une disposition est jugée invalide, les autres dispositions restent pleinement en vigueur.

### 16.2 Renonciation

Le fait de ne pas faire appliquer une disposition ne vaut pas renonciation.

### 16.3 Cession

Le Prestataire peut céder les présentes Conditions dans le cadre d'une fusion, d'une acquisition, d'une réorganisation d'entreprise ou d'une cession d'actifs. Les utilisateurs seront informés au moins 30 jours à l'avance de tout changement de l'entité contractante et, lorsque la loi l'exige, un nouveau consentement sera recueilli. Vous ne pouvez céder les présentes Conditions sans consentement écrit préalable.

### 16.4 Intégralité du contrat

Les présentes Conditions, ainsi que la Politique de confidentialité, le CLUF, l'Aperçu du cadre juridique, la Politique d'assistance et de mises à jour, la Politique de divulgation des vulnérabilités, l'Avertissement relatif aux marques et les Licences open source fournis avec AutoBrew (Réglages → Mentions légales), ainsi que la licence MIT sous laquelle le code source d'AutoBrew est publié, constituent l'intégralité de l'accord entre vous et le Prestataire.

### 16.5 Modifications

Le Prestataire peut mettre à jour les présentes Conditions. Les modifications importantes sont notifiées au moins 30 jours à l'avance par l'intermédiaire des Services ou par e-mail et, lorsque le droit applicable de la protection des consommateurs l'exige, ne prennent effet qu'après une nouvelle acceptation. La poursuite de l'utilisation après des modifications non importantes vaut acceptation.

### 16.6 Délai de prescription

Les réclamations au titre des présentes Conditions sont soumises aux délais de prescription légaux du droit applicable. Cela n'affecte aucun délai de prescription impératif du pays de résidence de l'utilisateur.

### 16.7 Notifications

Les notifications destinées au Prestataire doivent être envoyées à `hello@digitalfreedom.co.za` (général) ou à `data-protection@digitalfreedom.co.za` (vie privée / DSGVO). Les notifications qui vous sont destinées peuvent être faites dans AutoBrew ou dans ses notes de version, ou par e-mail lorsque vous avez contacté le Prestataire par e-mail.

### 16.8 Langue

Les présentes Conditions sont publiées en plusieurs langues. **Pour un consommateur, la version rédigée dans une langue officielle de son lieu de résidence habituelle fait foi** lorsqu'une telle version existe. La version anglaise fait foi pour les clients professionnels et pour les langues dans lesquelles aucune version n'existe. Il s'agit de l'inverse de la clause habituelle, et ce choix est délibéré : une clause rendant l'anglais contraignant n'est pas valable en France, en Belgique, en Pologne, en Italie, au Québec ou en Türkiye, et déclarer les traductions non contraignantes ôterait toute raison d'être à leur établissement.

---

Assistance : support@digitalfreedom.co.za · https://support.apps.digitalfreedom.co.za

(c) 2025-2026 DigitalFreedom Global LLC. Tous droits réservés.
