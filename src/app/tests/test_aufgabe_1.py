from __future__ import annotations

import random
import unittest

from src.app.routes.cart import calculate_product_sum_with_discount_util


def fill_dicts_with_prices(prices: list[int]) -> list[dict]:
    dicts_for_test = []
    for price in prices:
        dict_product_info = {
            'user_id': random.randint(1, 10),
            'product_id': random.randint(1, 10),
            'product_name': "Generic product name",
            'description': "Generic product description",
            'image': "Generic product image",
            'price': price,
            'stock': random.randint(1, 300)
        }
        dicts_for_test.append(dict_product_info)

    return dicts_for_test


class TestCalculatePrice(unittest.TestCase):

    def test_full_discount(self):
        prices = fill_dicts_with_prices([7, 6, 5, 4, 3])
        total = calculate_product_sum_with_discount_util(prices)
        self.assertEqual(7, total)

    def test_no_discount(self):
        prices = fill_dicts_with_prices([3, 4, 5, 6, 7])
        total = calculate_product_sum_with_discount_util(prices)
        self.assertEqual(25, total)

    def test_no_discount_2(self):
        prices = fill_dicts_with_prices([1, 2, 3, 4, 5])
        total = calculate_product_sum_with_discount_util(prices)
        self.assertEqual(15, total)

    def test_not_item(self):
        prices = []
        total = calculate_product_sum_with_discount_util(prices)
        self.assertEqual(0, total)

    def test_same_price(self):
        prices = fill_dicts_with_prices([10, 1, 1, 6])
        total = calculate_product_sum_with_discount_util(prices)
        self.assertEqual(16, total)

    def test_same_price_2(self):
        prices = fill_dicts_with_prices([10, 10, 10, 10])
        total = calculate_product_sum_with_discount_util(prices)
        self.assertEqual(10, total)

    def test_same_price_3(self):
        prices = fill_dicts_with_prices([1, 1, 1, 1])
        total = calculate_product_sum_with_discount_util(prices)
        self.assertEqual(1, total)

    def test_some_discount(self):
        prices = fill_dicts_with_prices([10, 11, 9, 10])
        total = calculate_product_sum_with_discount_util(prices)
        self.assertEqual(22, total)


if __name__ == '__main__':
    unittest.main()
