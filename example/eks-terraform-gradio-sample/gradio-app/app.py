import gradio as gr

def greet(name):
    return f"こんにちは、{name}さん！✨"

demo = gr.Interface(
    fn=greet,
    inputs="text",
    outputs="text",
    title="シンプルなデモアプリ",
    description="名前を入力してください！",
)

if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860)
