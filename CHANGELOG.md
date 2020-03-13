# 2.2.0

Re-adds `Enum.thru/2`. Not redundant with `Enum.each/2` since it returns the
original enum instead of `:ok` 🤦🏼‍♂️.

# 2.1.0

Adds `Enum.find_by/3` and `Enum.find_by/4`.

# 2.0.0

*Breaking*: Removes `Enum.thru/2` as it was redundant with `Enum.each/2`
Adds `tap/2` and `thru/2`
