# Lane4 DotEnv

### Ein Support-Tool zum Auslesen von .env-Dateien für globale und geschützte Kontexte

## Beschreibung

Das Lane4 DotEnv-Tool ermöglicht das Auslesen von `.env*`-Dateien gemäß der für .env Dateien vordefinierten Regeln. Die ausgelesenen Werte werden können in der globalen `$_ENV`-Variable, oder in geschützten Kontexten, wie einer Anwendungsdomäne verfügbar gemacht werden.

Die `.env*`-Dateien müssen dafür in einem Unterverzeichnis abgelegt und über die Methode `load($path, false)` ausgelesen werden. Diese Vorgehensweise erlaubt es, abweichende Einstellungen im Vergleich zum globalen `$_ENV` vorzunehmen, ohne Wechselwirkungen zu verursachen. Dies ist besonders nützlich, wenn eine monolitische Anwendung refaktorisiert werden soll und geschützte Bereiche mit eigenen Werten innerhalb einer bestehenden Anwendung entstehen sollen.


## Beispielcode

```php
use Land4\DotEnv\DotEnv;

$dotEnv = new DotEnv();
// Werte in $_ENV laden
$dotEnv->load($appRootPath);

// Nicht in $_ENV laden und Ergebnis als Array zurückgeben
$domainEnv = $dotEnv->load($domainRootPath, false);
```

## Datentypen

Das Tool erkennt und verarbeitet die folgenden Datentypen:

- `string`
- `bool`
- `numerics (int, float)`
- `array (mit TypeCasting der Werte)`

Eine Besonderheit ist die Unterstützung sowohl numerischer als auch assoziativer Arrays in `.env*`-Dateien.

```.env
TYPE_INT=1
TYPE_BOOL=true
TYPE_STRING=teststring
TYPE_ARRAY=[1,2,3,test=>hallo,test2=>true,test3=>[1,2,3,4]]

DB_HOST=testHost
DB_NAME=testName
HOME=~
DATABASE_URL=mysql://${DB_HOST}:${DB_NAME}@localhost
```

---

## Lieferumfang im Github Repository

- **SourceFile**: 
  - src/DotEnv.php
  - tests/DotEnvTest.php
- **Docker-basierte Umgebung**: PHP 8.3 (inkl. xDebug)
  - Dockerfile
  - Docker Compose
  - .env
- **GIT**:
  - git-pre-commit-hook.sh
- **Support**: Makefile mit folgenden Befehlen:
  - `make build`: Erzeugt ein PHP-CLI Docker-Image
  - `make remove`: Entfernt hier genutzte container, images, networks, volumes und caches
  - `make install`: Composer Installation
  - `make update`: Composer Update
  - `make autoload`: Composer Autoload-Dump-File
  - `make phpcs`: Coding Style Prüfung 
  - `make phpunit`: Ausführung aller Tests
  - `make phpunit-reports`: Ausführung aller Tests inkl. Dokumentation
  - `make phpunit-coverage`: Ausführung aller Tests inkl. Code Coverage auf der Konsole
  - `make phpstan`: Vollständige Code-Analyse (level 8)
- **Dokumentation**:
  - README.md

Der Aufbau des DockerFiles zum erstellen des PHP Images ist etwas umfänglicher gebaut als es für dieses Tool notwendig ist, da das resultierende PHP Image in verschiedenen Lane4 Tools eingesetzt wird.

Es wird auch darauf geachtet, das unsere Images so klein wie möglich sind und auf eurem System durch ggf. wiederholtes bauen der Images keine unnötigen Dateien verbleiben.

---

Viel Freude bei der Nutzung!
