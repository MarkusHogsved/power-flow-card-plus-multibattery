# Changelog

## 0.3.7-mb.2

- Fix: the flow lines no longer drift away from the circles when
  `additional_batteries` is used. The row of SOC chips made the card 16 px
  taller, and the line layers are anchored to the bottom of the card, so
  they moved down by the same amount (the battery→home line ended inside the
  battery circle). They are now shifted back by exactly the height of the
  chip row. Cards without the option are unchanged.

## 0.3.7-mb.1

- First release: Power Flow Card Plus 0.3.7 with
  `entities.battery.additional_batteries`. Each additional battery is shown
  as a compact SOC chip under the battery label (coloured while charging or
  discharging when a power entity is given), and the battery circle gets a
  hover tooltip with every battery's SOC and power. Chips follow the card's
  normal tap/hold/double-tap handling. Without the option the card is
  unchanged.
- Built from flixlix/flixlix-cards with the patches in `patches/`; 7 new
  tests (SOC/power reading, kW conversion, `invert_state`, unavailable
  entities, tooltip text, rendering with and without the option).
