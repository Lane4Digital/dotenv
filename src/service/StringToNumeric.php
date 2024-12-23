<?php

declare(strict_types=1);

namespace Lane4\DotEnv\service;

/**
 * Type cast string to numeric
 */
class StringToNumeric
{
    /**
     * @return int|float|string|null
     */
    public function __invoke(?string $value = null)
    {
        return is_numeric($value) ? $value + 0 : $value;
    }
}
