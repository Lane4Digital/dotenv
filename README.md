
# Jardis DotEnv

### A support tool for reading .env files for global and protected contexts

## Description

The Lane4 DotEnv tool allows reading `.env*` files according to predefined rules for .env files. The read values can be made available in the global `$_ENV` variable or in protected contexts such as an application domain.

The `.env*` files must be stored in a subdirectory and read using the method `load($path, false)`. This approach allows different settings compared to the global `$_ENV` without causing interference. This is especially useful when refactoring a monolithic application to create protected areas with their own values within an existing application.

## Example Code

```php
use Jardis\DotEnv;

$dotEnv = new DotEnv();
// Load values into $_ENV
$dotEnv->load($appRootPath);

// Do not load into $_ENV and return the result as an array
$domainEnv = $dotEnv->load($domainRootPath, false);
```

## Data Types

The tool recognizes and processes the following data types:

- `string`
- `bool`
- `numerics (int, float)`
- `array (with type casting of values)`

A special feature is the support for both numeric and associative arrays in `.env*` files.

```.env
TYPE_INT=1
TYPE_BOOL=true
TYPE_STRING=teststring
TYPE_ARRAY=[1,2,3,test=>hello,test2=>true,test3=>[1,2,3,4]]

DB_HOST=testHost
DB_NAME=testName
HOME=~
DATABASE_URL=mysql://${DB_HOST}:${DB_NAME}@localhost
```

---

## Content in the GitHub Repository

- **Source File**:
  - src/DotEnv.php
  - tests/DotEnvTest.php
- **Docker-based Environment**: PHP 8.3 (incl. xDebug)
  - Dockerfile
  - Docker Compose
  - .env
- **GIT**:
  - git-pre-commit-hook.sh
- **Support**: Makefile with the following commands:
  - `make build`: Builds a PHP-CLI Docker image
  - `make remove`: Removes used containers, images, networks, volumes, and caches
  - `make install`: Composer installation
  - `make update`: Composer update
  - `make autoload`: Composer autoload dump file
  - `make phpcs`: Coding style check
  - `make phpunit`: Runs all tests
  - `make phpunit-reports`: Runs all tests including documentation
  - `make phpunit-coverage`: Runs all tests including code coverage on the console
  - `make phpstan`: Complete code analysis (level 8)
- **Documentation**:
  - README.md

The structure of the Dockerfile for creating the PHP image is more comprehensive than necessary for this tool, as the resulting PHP image is used in various Lane4 tools.

We also ensure that our images are as small as possible and that no unnecessary files remain on your system after repeated image builds.

---

Enjoy using it!
