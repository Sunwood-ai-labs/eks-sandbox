import unittest
from app import calculate

class TestCalculatorApp(unittest.TestCase):
    def test_addition(self):
        """足し算のテスト"""
        result = calculate(5, 3, "足し算")
        self.assertEqual(result, "5 + 3 = 8")

    def test_subtraction(self):
        """引き算のテスト"""
        result = calculate(10, 4, "引き算")
        self.assertEqual(result, "10 - 4 = 6")

    def test_multiplication(self):
        """掛け算のテスト"""
        result = calculate(6, 7, "掛け算")
        self.assertEqual(result, "6 × 7 = 42")

    def test_division(self):
        """割り算のテスト"""
        result = calculate(15, 3, "割り算")
        self.assertEqual(result, "15 ÷ 3 = 5.0")

    def test_division_by_zero(self):
        """0による割り算のテスト"""
        result = calculate(10, 0, "割り算")
        self.assertEqual(result, "0で割ることはできません")

    def test_invalid_input(self):
        """不正な入力のテスト"""
        result = calculate("abc", 5, "足し算")
        self.assertEqual(result, "数値を入力してください")

if __name__ == '__main__':
    unittest.main()
