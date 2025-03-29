import unittest
from app import increment, reset

class TestCounterApp(unittest.TestCase):
    def setUp(self):
        # 各テスト前にカウンターをリセット
        reset()

    def test_increment(self):
        """インクリメント機能のテスト"""
        initial = increment()
        self.assertEqual(initial, "現在のカウント: 1")
        
        # 複数回のインクリメント
        second = increment()
        self.assertEqual(second, "現在のカウント: 2")

    def test_reset(self):
        """リセット機能のテスト"""
        # まずカウントアップ
        increment()
        increment()
        
        # リセット
        result = reset()
        self.assertEqual(result, "現在のカウント: 0")

if __name__ == '__main__':
    unittest.main()
