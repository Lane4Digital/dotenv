<?php

declare(strict_types=1);

namespace Lane4\DotEnv\service;

/**
 * Type cast string to bool
 */
class StringToBool
{
    /**
     * @return bool|string|null
     */
    public function __invoke(?string $value = null)
    {
        if (is_null($value)) {
            return null;
        }

        $result = filter_var($value, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);

        return $result ?? $value;
    }
}
