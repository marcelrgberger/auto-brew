<!-- doc-id: CRA_USER_INFORMATION | lang: en | area: apps/documents | version: 1.0.0 | valid-from: 2026-09-01 | supersedes: none | owner: Marcel R. G. Berger | next-review: 2027-06-01 -->
<!-- generated-for: AutoBrew | generated: 2026-10-15 | source: legal/apps/documents/CRA_USER_INFORMATION.en.md | SBOM: none published (no SBOM found in the repository); portfolio transport-encryption sentence replaced by AutoBrew facts (§ 4); placeholders: APP_NAME=AutoBrew, APP_VERSION=2.5.3, BUNDLE_ID=za.co.digitalfreedom.AutoBrew, SUPPORT_END=October 2031 for 2.5.3 (GitHub release 2026-10-15) and five years from release for later versions, APP_DOMAIN: no product domain (§ 6 states that the declaration is not yet issued), AUTH_METHOD=none, storage=on the Mac; adaptations: direct distribution and Sparkle updates (§ 3, § 8), generator instruction in the header replaced by a user-facing statement, sibling links replaced by document names | translated-from: en -->
# INFORMACJE O BEZPIECZEŃSTWIE DOTYCZĄCE TEGO PRODUKTU

## Informacje i instrukcje dla użytkownika — załącznik II do rozporządzenia (UE) 2024/2847 (akt o cyberodporności)

**Produkt:** AutoBrew, wersja 2.5.3 i nowsze
**Ma zastosowanie od:** załącznik II do aktu o cyberodporności ma zastosowanie do produktów wprowadzanych do obrotu w UE od
**11 grudnia 2027 r.**, a wcześniej do każdego istniejącego produktu, który zostanie poddany istotnej modyfikacji.
Niniejsze informacje są udostępniane dla AutoBrew przed tą datą.

---

## 1. Producent

DigitalFreedom — marka DigitalFreedom Global LLC
30 N Gould St, Ste N, Sheridan, WY 82801, United States
Pojedynczy punkt kontaktowy: hello@digitalfreedom.co.za

## 2. Gdzie zgłosić podatność

Zgłoszenia dotyczące bezpieczeństwa: <https://security.digitalfreedom.co.za> lub `security@digitalfreedom.co.za`.
Pełny proces, wraz z bezpieczną przystanią (safe harbour), opisano w Zasadach skoordynowanego ujawniania podatności (Ustawienia → Informacje prawne → Zgłaszanie podatności);
w formacie do odczytu maszynowego: https://digitalfreedom.co.za/.well-known/security.txt.

## 3. Identyfikacja produktu

AutoBrew — `za.co.digitalfreedom.AutoBrew` — aplikacja dla systemu macOS (macOS 14 lub nowszy), dystrybuowana bezpośrednio jako poświadczony notarialnie przez Apple (notarized) plik do pobrania z GitHub Releases (https://github.com/marcelrgberger/auto-brew/releases) oraz za pośrednictwem repozytorium Homebrew tap `marcelrgberger/homebrew-tap`.
Zainstalowana wersja jest wyświetlana w ustawieniach aplikacji w sekcji O aplikacji, nad sekcją Informacje prawne.

## 4. Przeznaczenie i zasadnicze właściwości w zakresie cyberbezpieczeństwa

AutoBrew utrzymuje pakiety Homebrew na komputerze Mac w aktualnym stanie zgodnie z ustawionymi przez użytkownika zasadami aktualizacji, zapewnia interfejs graficzny do przeglądania, instalowania, aktualizowania i usuwania pakietów cask Homebrew oraz tworzy, przywraca i migruje migawki danych użytkownika aplikacji. Właściwości w zakresie bezpieczeństwa: brak reklamowego SDK i identyfikatora reklamowego; wyłącznie powiadomienia lokalne;
uwierzytelnianie: brak — aplikacja działa wyłącznie lokalnie; przechowywanie danych: wyłącznie na urządzeniu.

W szczególności w odniesieniu do AutoBrew: połączenia nawiązywane przez sam AutoBrew wykorzystują protokół HTTPS; adresy pobierania pakietów instalowanych przez Homebrew ustalają ich wydawcy oraz projekt Homebrew. Każde wydanie jest podpisane certyfikatem Apple Developer ID, poświadczone notarialnie przez Apple (notarized) i zbudowane z użyciem Hardened Runtime. Aktualizacje dostarczane za pośrednictwem wbudowanego mechanizmu aktualizacji (Sparkle) są przed instalacją weryfikowane względem podpisu EdDSA (Ed25519). AutoBrew przechowuje swoje dane na komputerze Mac lub w wybranej przez użytkownika lokalizacji przechowywania migawek; nie przesyła żadnych danych producentowi.

## 5. Znane lub dające się przewidzieć okoliczności powodujące znaczne ryzyko w zakresie cyberbezpieczeństwa

- **AutoBrew działa poza App Sandbox**, ponieważ musi uruchamiać `brew`, `ditto` i inne narzędzia systemowe. Działa z uprawnieniami zalogowanego użytkownika.
- **Oprogramowanie instalowane lub aktualizowane za pomocą Homebrew** jest publikowane przez podmioty trzecie i działa z uprawnieniami użytkownika. Przy włączonych automatycznych aktualizacjach nowe wersje są instalowane zgodnie z ustawionymi przez użytkownika zasadami aktualizacji, bez odrębnego potwierdzenia każdej aktualizacji w kategorii „install automatically” (instaluj automatycznie).
- **Migawki zawierają kopie danych aplikacji**, które mogą obejmować dane logowania, tokeny lub inne informacje wrażliwe przechowywane przez aplikację w jej folderach danych użytkownika. Migawki i wyeksportowane pliki migawek nie są szyfrowane przez AutoBrew; każdy, kto ma dostęp do lokalizacji migawek, wykorzystywanego do tego dysku zewnętrznego lub wyeksportowanego pliku, może je odczytać. Automatyczne migawki przed aktualizacjami są domyślnie włączone (Ustawienia → Migawki).
- **Instalacja Homebrew** z poziomu AutoBrew uruchamia oficjalny skrypt instalacyjny Homebrew pobrany z serwisu GitHub.

Żadna z tych okoliczności nie stanowi znanej podatności. Okoliczności wykryte później są usuwane w drodze aktualizacji bezpieczeństwa, a jeżeli osiągają progi określone w art. 14, są zgłaszane zgodnie z wymogami.

## 6. Deklaracja zgodności UE

Deklaracja zgodności UE jest wymagana od 11 grudnia 2027 r. i nie została jeszcze wydana dla AutoBrew. Po jej wydaniu będzie dostępna na żądanie pod adresem hello@digitalfreedom.co.za, a miejsce jej udostępnienia zostanie wskazane w tym miejscu.

## 7. Wsparcie techniczne i okres wsparcia

Podatności bezpieczeństwa są obsługiwane, a aktualizacje bezpieczeństwa dostarczane **co najmniej do października 2031 r. w przypadku wersji 2.5.3** (opublikowanej w GitHub Releases w dniu 15 października 2026 r.), a w przypadku każdej późniejszej wersji co najmniej do tego samego miesiąca pięć lat po opublikowaniu tej wersji w GitHub Releases.
Ogólne zobowiązanie oraz zakres pojęcia „wsparcie” opisano w Zasadach wsparcia i aktualizacji (Ustawienia → Informacje prawne → Zasady wsparcia i aktualizacji). Zgłoszenia do wsparcia technicznego:
<https://support.apps.digitalfreedom.co.za>.

## 8. Bezpieczne korzystanie przez cały okres eksploatacji produktu

- **Instalacja i pierwsze użycie:** instalować wyłącznie z GitHub Releases pod adresem https://github.com/marcelrgberger/auto-brew/releases lub za pośrednictwem repozytorium Homebrew tap `marcelrgberger/homebrew-tap`; macOS weryfikuje podpis Developer ID oraz poświadczenie notarialne przy pierwszym otwarciu aplikacji. Do uzyskania bezpiecznej konfiguracji domyślnej nie jest wymagana żadna konfiguracja — aplikacja nie ma żadnego opcjonalnego przepływu danych do producenta.
- **Aktualizacje bezpieczeństwa** są dostarczane za pośrednictwem wbudowanego mechanizmu aktualizacji AutoBrew (Ustawienia → Aktualizacje → Sprawdź aktualizacje), za pośrednictwem repozytorium Homebrew tap lub jako nowy plik do pobrania z GitHub Releases. Prosimy pozostawić włączone automatyczne sprawdzanie aktualizacji; jeżeli je Państwo wyłączą, prosimy regularnie sprawdzać dostępność aktualizacji — nieaktualna wersja nie otrzymuje już poprawek.
- **Zmiany wpływające na bezpieczeństwo:** przyznanie uprawnień systemu operacyjnego rozszerza zakres, do którego aplikacja ma dostęp; AutoBrew prosi o uprawnienie do wyświetlania powiadomień, a każde uprawnienie można w dowolnym momencie cofnąć w Ustawieniach systemowych. Wybór zewnętrznej lokalizacji przechowywania migawek, włączenie automatycznej instalacji dla danej kategorii pakietów oraz uruchamianie poleceń wykonywanych przed migawką dla poszczególnych pakietów rozszerzają zakres działań, które AutoBrew wykonuje w Państwa imieniu.
- **Wycofanie z użytku:** odinstalowanie usuwa aplikację. Aby usunąć jej dane lokalne, należy usunąć foldery wymienione w sekcji 3.6 Polityki prywatności, w tym wybraną przez Państwa zewnętrzną lokalizację migawek oraz wszelkie wyeksportowane pliki migawek. AutoBrew nie ma konta i nie przechowuje żadnych danych na serwerach producenta.

## 9. Zestawienie komponentów oprogramowania (SBOM)

Dla AutoBrew nie jest publikowane zestawienie komponentów oprogramowania (SBOM). Komponenty podmiotów trzecich i ich licencje wymieniono w dokumencie Licencje open source (Ustawienia → Informacje prawne → Licencje open source).
