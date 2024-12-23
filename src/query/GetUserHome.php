<?php

declare(strict_types=1);

namespace Lane4\DotEnv\query;

use RuntimeException;

/**
 * Return home path of active user
 */
class GetUserHome
{
    public const HOME_DRIVE = 'HOMEDRIVE';
    public const HOME_PATH = 'HOMEPATH';
    public const HOME = 'HOME';

    /** @throws RuntimeException */
    public function __invoke(?string $value = null): ?string
    {
        if (is_string($value) && str_contains($value, '~')) {
            $value = trim($value);

            if (strpos($value, '~') === 0) {
                $homeDir = $this->getHomeDir();

                if ($homeDir === false) {
                    throw new RuntimeException('HOME environment variable is not set!');
                }

                return str_replace('~', $homeDir, $value);
            }
        }

        return $value;
    }

    protected function getHomeDir()
    {
        return ($this->getOsType() === 'Windows')
            ? getenv(static::HOME_DRIVE) . getenv(static::HOME_PATH)
            : getenv(static::HOME);
    }

    protected function getOsType(): string
    {
        return PHP_OS_FAMILY;
    }
}
