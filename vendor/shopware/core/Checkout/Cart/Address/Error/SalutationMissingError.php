<?php declare(strict_types=1);

namespace Shopware\Core\Checkout\Cart\Address\Error;

use Shopware\Core\Checkout\Cart\Error\Error;
use Shopware\Core\Framework\Log\Package;

#[Package("checkout")]
abstract class SalutationMissingError extends Error
{
    protected const KEY = "salutation-missing";

    /**
     * @var array<string, string>
     */
    protected array $parameters;

    abstract public function getId(): string;

    public function getMessageKey(): string
    {
        return $this->getId();
    }

    public function getLevel(): int
    {
        return 1;
    }

    public function blockOrder(): bool
    {
        return false;
    }

    /**
     * @return array<string, string>
     */
    public function getParameters(): array
    {
        return $this->parameters;
    }
}
