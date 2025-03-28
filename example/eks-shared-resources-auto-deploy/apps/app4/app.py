import gradio as gr
import numpy as np
from PIL import Image
import cv2

def process_image(image, operation):
    if operation == "グレースケール":
        gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
        return np.stack([gray, gray, gray], axis=-1)
    elif operation == "ぼかし":
        return cv2.GaussianBlur(image, (15, 15), 0)
    return image

with gr.Blocks(title="画像処理アプリ") as demo:
    gr.Markdown("# 画像処理アプリ")
    gr.Markdown("画像をアップロードして、様々な効果を適用できます。")
    
    with gr.Row():
        input_image = gr.Image(label="入力画像")
        output_image = gr.Image(label="処理後の画像")
    
    operation = gr.Radio(
        ["グレースケール", "ぼかし"],
        label="適用する効果",
        value="グレースケール"
    )
    
    process_btn = gr.Button("処理開始")
    
    process_btn.click(
        process_image,
        inputs=[input_image, operation],
        outputs=output_image
    )

if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860)
