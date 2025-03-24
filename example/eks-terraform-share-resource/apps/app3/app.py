import gradio as gr

def transform_text(text, transformation):
    if transformation == "大文字に変換":
        return text.upper()
    elif transformation == "小文字に変換":
        return text.lower()
    elif transformation == "逆さま文字":
        return text[::-1]
    elif transformation == "スペース除去":
        return text.replace(" ", "")
    return text

with gr.Blocks(title="テキスト変換アプリ") as demo:
    gr.Markdown("# テキスト変換アプリ")
    
    input_text = gr.Textbox(
        label="変換したいテキスト",
        placeholder="ここにテキストを入力してください..."
    )
    
    transformation = gr.Radio(
        ["大文字に変換", "小文字に変換", "逆さま文字", "スペース除去"],
        label="変換タイプ",
        value="大文字に変換"
    )
    
    output_text = gr.Textbox(label="変換結果")
    
    transform_btn = gr.Button("変換")
    
    transform_btn.click(
        transform_text,
        inputs=[input_text, transformation],
        outputs=output_text
    )

if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860)
