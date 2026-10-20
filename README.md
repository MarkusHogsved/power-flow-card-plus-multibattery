# Power Flow Card Plus – multibattery

En fork av [Power Flow Card Plus](https://github.com/flixlix/power-flow-card-plus) v0.3.7 (källkod i monorepot [flixlix/flixlix-cards](https://github.com/flixlix/flixlix-cards)) som låter batteri-cirkeln visa **flera batterier**.

Kortet registreras som `custom:power-flow-card-plus`, precis som originalet. Befintliga kort fungerar oförändrade, men originalet och den här forken kan inte vara inlästa samtidigt: ta bort originalets dashboard-resurs, eller avinstallera det i HACS, innan du installerar forken.

## Nytt alternativ: `entities.battery.additional_batteries`

```yaml
type: custom:power-flow-card-plus
entities:
  battery:
    entity:
      consumption: sensor.growatt_bms_total_discharge
      production: sensor.growatt_bms_total_charge
    state_of_charge: sensor.growatt_soc
    additional_batteries:
      - name: Victron
        icon: mdi:home-battery-outline
        state_of_charge: sensor.victron_soc
        entity: sensor.victron_battery_power   # valfri, positiv = laddar
      - name: Anker
        icon: mdi:power-plug-battery-outline
        state_of_charge: sensor.anker_soc
```

| Nyckel | Krävs | Beskrivning |
|---|---|---|
| `state_of_charge` | ja | Entitet med laddnivå i %. |
| `entity` | nej | Effekt i W/kW. Positiv = laddar, negativ = laddar ur. Med effekten färgas siffran (laddar/laddar ur) och den visas i tooltipen. |
| `invert_state` | nej | Vänder tecknet på `entity`. |
| `name` | nej | Visningsnamn, annars entitetens friendly_name. |
| `icon` | nej | Standard `mdi:battery-outline`. |
| `state_of_charge_decimals` | nej | Antal decimaler i SOC, standard 0. |
| `tap_action` / `hold_action` / `double_tap_action` | nej | Som för övriga entiteter i kortet. Utan dessa öppnas SOC-entitetens more-info om `clickable_entities` är på. |

Varje extra batteri visas som en liten rad (ikon + SOC) under batteri-etiketten. Håller man muspekaren över batteri-cirkeln visas en tooltip med alla batteriers SOC och effekt. Utan `additional_batteries` ser kortet ut exakt som originalet.

## Bygga om

Ändringen finns som patch i `patches/`, mot flixlix-cards commit `28df3548537a2a4e6d6174d4f5736c3ca3fd6e2e`:

```sh
git clone https://github.com/flixlix/flixlix-cards.git && cd flixlix-cards
git checkout 28df3548537a2a4e6d6174d4f5736c3ca3fd6e2e
git am ../patches/*.patch
pnpm install && cd packages/flixlix-cards/power-flow-card-plus && pnpm build
```

## Licens

MIT, som originalet (Copyright flixlix). Se `LICENSE`.
