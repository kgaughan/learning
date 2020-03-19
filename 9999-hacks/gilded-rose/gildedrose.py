# /usr/bin/env python3

from collections import namedtuple
import pprint


class Item:

    __slots__ = ["name", "sell_in", "quality"]

    def __init__(self, name, sell_in, quality):
        self.name = name
        self.sell_in = sell_in
        self.quality = quality

    def __repr__(self):
        return (
            f'Item(name="{self.name}", sell_in={self.sell_in}, quality={self.quality})'
        )


def bound(n):
    return max(min(n, 50), 0)


def update_ordinary(item):
    item.sell_in -= 1
    quality = (item.quality - 2) if item.sell_in < 0 else (item.quality - 1)
    item.quality = bound(quality)


def update_legendary(_item):
    pass


def update_brie(item):
    item.sell_in -= 1
    item.quality = bound(item.quality + 1)


def update_backstage_passes(item):
    item.sell_in -= 1
    quality = item.quality
    if item.sell_in > 10:
        quality += 1
    elif item.sell_in > 5:
        quality += 2
    elif item.sell_in > 0:
        quality += 3
    else:
        quality = 0
    item.quality = bound(quality)


def update_conjured(item):
    item.sell_in -= 1
    item.quality = bound(item.quality - 2)


METHODS = [
    (lambda item: item.name == "Sulfuras, Hand of Ragnaros", update_legendary),
    (lambda item: item.name == "Aged Brie", update_brie),
    (lambda item: item.name.startswith("Backstage passes"), update_backstage_passes),
    (lambda item: item.name.startswith("Conjured"), update_conjured),
    (lambda _: True, update_ordinary),
]


def update(items):
    for item in items:
        for detector, updater in METHODS:
            if detector(item):
                updater(item)
                break


def main():
    items = [
        Item("+5 Dexterity Vest", 10, 20),
        Item("Aged Brie", 2, 0),
        Item("Elixir of the Mongoose", 5, 7),
        Item("Sulfuras, Hand of Ragnaros", 0, 80),
        Item("Backstage passes to a TAFKAL80ETC concert", 15, 20),
        Item("Conjured Mana Cake", 3, 6),
    ]
    print("Initial values:")
    while any(item.sell_in > 0 for item in items):
        update(items)
        pprint.pprint(items)
    print("Done!")


if __name__ == "__main__":
    main()
