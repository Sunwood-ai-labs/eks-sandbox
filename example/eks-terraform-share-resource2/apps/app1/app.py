import gradio as gr

count = 0

def increment():
    global count
    count += 1
    return f"現在のカウント: {count}"

def reset():
    global count
    count = 0
    return f"現在のカウント: {count}"

with gr.Blocks(title="シンプルカウンターアプリ") as demo:
    gr.Markdown("# シンプルカウンターアプリ")
    output = gr.Textbox(value="現在のカウント: 0", label="カウンター")
    with gr.Row():
        increment_btn = gr.Button("カウントアップ")
        reset_btn = gr.Button("リセット")
    
    increment_btn.click(increment, outputs=output)
    reset_btn.click(reset, outputs=output)

if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860)
