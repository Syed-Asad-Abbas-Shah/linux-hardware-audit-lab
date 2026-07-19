# Live command outputs (reference capture)

These files were produced on the author's **HP EliteBook 840 G7** running **CachyOS** on **2026-07-19**.

## Format

Each file starts with:

```text
$ <command>
---
<stdout/stderr>
```

## Privacy

Sensitive values are replaced with placeholders such as:

- `<REDACTED_MAC>`
- `<REDACTED_IP>`
- `<REDACTED_SERIAL>`
- `<REDACTED_MACHINE_ID>`
- `<REDACTED_HOSTNAME>`

## Regenerating

From the repository root:

```bash
./scripts/collect-hardware-info.sh
sudo ./scripts/collect-hardware-info.sh --with-sudo
```

Scrub personal identifiers before publishing your own captures.
