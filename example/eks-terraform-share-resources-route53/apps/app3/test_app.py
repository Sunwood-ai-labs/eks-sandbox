import unittest
from app import transform_text

class TestTextTransformApp(unittest.TestCase):
    def test_uppercase_transform(self):
        """大文字変換のテスト"""
        result = transform_text("hello world", "大文字に変換")
        self.assertEqual(result, "HELLO WORLD")

    def test_lowercase_transform(self):
        """小文字変換のテスト"""
        result = transform_text("HELLO WORLD", "小文字に変換")
        self.assertEqual(result, "hello world")

    def test_reverse_transform(self):
        """テキスト反転のテスト"""
        result = transform_text("hello world", "逆さま文字")
        self.assertEqual(result, "dlrow olleh")

    def test_remove_spaces(self):
        """スペース除去のテスト"""
        result = transform_text("hello world test", "スペース除去")
        self.assertEqual(result, "helloworldtest")

    def test_empty_input(self):
        """空入力のテスト"""
        result = transform_text("", "大文字に変換")
        self.assertEqual(result, "")

    def test_special_characters(self):
        """特殊文字を含む入力のテスト"""
        text = "Hello! こんにちは 123"
        result = transform_text(text, "大文字に変換")
        self.assertEqual(result, "HELLO! こんにちは 123")

if __name__ == '__main__':
    unittest.main()
