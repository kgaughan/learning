import unittest

from gildedrose import Item, update


class TestGildedRose(unittest.TestCase):
    def test_normal_item(self):
        item = Item("Normal", sell_in=5, quality=10)
        while item.sell_in > 0:
            update([item])
            self.assertEqual(item.quality - item.sell_in, 5)

        update([item])
        self.assertEqual(item.sell_in, -1)
        self.assertEqual(item.quality, 3)

        update([item])
        self.assertEqual(item.sell_in, -2)
        self.assertEqual(item.quality, 1)

        update([item])
        self.assertEqual(item.sell_in, -3)
        self.assertEqual(item.quality, 0)

        update([item])
        self.assertEqual(item.sell_in, -4)
        self.assertEqual(item.quality, 0)

    def test_brie(self):
        item = Item("Aged Brie", sell_in=0, quality=0)
        while item.quality < 50:
            update([item])
            self.assertEqual(item.quality, -item.sell_in)

        update([item])
        self.assertEqual(item.sell_in, -51)
        self.assertEqual(item.quality, 50)

        update([item])
        self.assertEqual(item.sell_in, -52)
        self.assertEqual(item.quality, 50)

    def test_sulfuras(self):
        item = Item("Sulfuras, Hand of Ragnaros", 0, 80)
        self.assertEqual(item.sell_in, 0)
        self.assertEqual(item.quality, 80)

        update([item])
        self.assertEqual(item.sell_in, 0)
        self.assertEqual(item.quality, 80)

    def test_conjoured(self):
        item = Item("Conjured Mana Cake", 3, 6)

        update([item])
        self.assertEqual(item.sell_in, 2)
        self.assertEqual(item.quality, 4)

        update([item])
        self.assertEqual(item.sell_in, 1)
        self.assertEqual(item.quality, 2)

        update([item])
        self.assertEqual(item.sell_in, 0)
        self.assertEqual(item.quality, 0)

    def test_backstage_passes(self):
        item = Item("Backstage passes to a TAFKAL80ETC concert", 15, 20)
        while item.sell_in > 11:
            update([item])
        self.assertEqual(item.quality, 24)

        while item.sell_in > 6:
            update([item])
        self.assertEqual(item.quality, 34)

        while item.sell_in > 1:
            update([item])
        self.assertEqual(item.quality, 49)

        update([item])
        self.assertEqual(item.quality, 0)
