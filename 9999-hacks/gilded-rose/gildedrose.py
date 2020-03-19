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


def bound(n, minimum, maximum):
    return max(min(n, maximum), minimum)


def update(items):
    for item in items:
        if item.name == "Sulfuras, Hand of Ragnaros":
            continue

        item.sell_in -= 1

        quality = item.quality
        if item.name == "Aged Brie":
            quality += 1
        elif item.name.startswith("Backstage passes"):
            if item.sell_in > 10:
                quality += 1
            elif item.sell_in > 5:
                quality += 2
            elif item.sell_in > 0:
                quality += 3
            else:
                quality = 0
        elif item.sell_in < 0 or item.name.startswith("Conjured"):
            quality -= 2
        else:
            quality -= 1

        item.quality = bound(quality, 0, 50)


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
