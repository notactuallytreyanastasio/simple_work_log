#!/bin/zsh

mkdir -p priv/years

for y in {2022,2023,2024,2025,2026}; do
  mkdir -p priv/years/$y
done

for i in {1..12}; do
  month=$(ruby -e "puts $i.to_s.rjust(2, '0')")
  for year in $(ls priv/years/); do
    mkdir priv/years/$year/$month
  done
done
