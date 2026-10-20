<p align="center"><img src="https://raw.githubusercontent.com/MarkusHogsved/power-flow-card-plus-multibattery/main/assets/icon.png" width="128" alt="Power Flow Card Plus multibattery"></p>

# Power Flow Card Plus – multibattery

[Power Flow Card Plus](https://github.com/flixlix/power-flow-card-plus) by
flixlix, with one addition: the battery circle can show **more than one
battery**.

Homes often have several storage systems: a hybrid inverter's battery, a UPS
in the basement, a portable power station. The original card has room for one
battery. This fork adds compact state-of-charge chips for the others under the
battery circle, plus a hover tooltip on the circle that lists every battery's
charge and power, so the card stays a single at-a-glance overview.

Everything else is the upstream card, unchanged. Without the new option the
card looks exactly like the original.

## Installation (HACS)

1. HACS → ⋮ → *Custom repositories* → add
   `https://github.com/MarkusHogsved/power-flow-card-plus-multibattery`,
   type *Dashboard*.
2. Install **Power Flow Card Plus (multibattery)**.
3. **Remove the original Power Flow Card Plus resource** (Settings →
   Dashboards → ⋮ → Resources), or uninstall it in HACS. Both register the
   same card type, `custom:power-flow-card-plus`, and only one can be loaded.
   Your existing cards keep working without changes.
4. Reload the browser. The console shows
   `⚡ Power Flow Card Plus v0.3.7-mb.3 is installed`.

## The new option: `entities.battery.additional_batteries`

```yaml
type: custom:power-flow-card-plus
entities:
  battery:
    entity:
      consumption: sensor.inverter_battery_discharge_power
      production: sensor.inverter_battery_charge_power
    state_of_charge: sensor.inverter_battery_soc
    additional_batteries:
      - name: Victron
        icon: mdi:home-battery-outline
        state_of_charge: sensor.victron_soc
        entity: sensor.victron_battery_power   # optional, positive = charging
      - name: Anker
        icon: mdi:power-plug-battery-outline
        state_of_charge: sensor.anker_soc
```

| Key | Required | Description |
|---|---|---|
| `state_of_charge` | yes | Entity with the state of charge in %. |
| `entity` | no | Battery power in W or kW. Positive = charging, negative = discharging. Colours the chip (charging / discharging) and adds the power to the tooltip. |
| `invert_state` | no | Flips the sign of `entity`. |
| `name` | no | Display name. Defaults to the SOC entity's friendly name. |
| `icon` | no | Defaults to `mdi:battery-outline`. |
| `state_of_charge_decimals` | no | Decimals for the SOC. Default 0. |
| `tap_action` / `hold_action` / `double_tap_action` | no | As for the card's other entities. Without them, a click opens the SOC entity's more-info dialog when `clickable_entities` is on. |

Each additional battery is shown as a small chip (icon + SOC) under the
battery label. It uses the card's battery colours: the "in" colour while
charging and the "out" colour while discharging. Hovering the battery circle
shows a tooltip such as:

```
Battery: 88% ↑1.3 kW
Victron: 90% ↑259 W
Anker: 70%
```

## How it is built

This repository holds no copy of the card's source. `patches/` contains the
change as `git format-patch` files against
[flixlix/flixlix-cards](https://github.com/flixlix/flixlix-cards) at commit
`28df3548537a2a4e6d6174d4f5736c3ca3fd6e2e` (card version 0.3.7), pinned in `package.json`.
`scripts/build.sh` clones that commit, applies the patches, runs the card's
type check and tests and bundles `dist/power-flow-card-plus-multibattery.js`.

- **Validate** (every push and PR): HACS validation and the full build
  including tests.
- **Release**: bumping `version` in `package.json` on main builds the card
  and publishes a GitHub release `v<version>` with the `.js` attached. HACS
  installs that asset. Release notes come from `CHANGELOG.md`.

Versioning: `<upstream card version>-mb.<n>`, e.g. `0.3.7-mb.1`. For a new
upstream version, move `upstream.commit` and rebase the patches.

## License

MIT, like the original. Copyright (c) flixlix (upstream card) and Markus
Hogsved (multibattery patches). See `LICENSE`.
