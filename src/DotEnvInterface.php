<?php

declare(strict_types=1);

namespace Lane4\DotEnv;

use Exception;

/**
 * The DotEnv Interface
 */
interface DotEnvInterface
{
    /**
     * @return array<string, mixed>|null
     * @throws Exception
     */
    public function load(string $pathToEnvFiles, bool $public = true): ?array;
}