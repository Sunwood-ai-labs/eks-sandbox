import gradio as gr

def calculate(num1, num2, operation):
    try:
        num1 = float(num1)
        num2 = float(num2)
        if operation == "足し算":
            return f"{num1} + {num2} = {num1 + num2}"
        elif operation == "引き算":
            return f"{num1} - {num2} = {num1 - num2}"
        elif operation == "掛け算":
            return f"{num1} × {num2} = {num1 * num2}"
        elif operation == "割り算":
            if num2 == 0:
                return "0で割ることはできません"
            return f"{num1} ÷ {num2} = {num1 / num2}"
    except ValueError:
        return "数値を入力してください"

with gr.Blocks(title="シンプル計算機") as demo:
    gr.Markdown("# シンプル計算機")
    with gr.Row():
        num1 = gr.Number(label="数値1")
        num2 = gr.Number(label="数値2")
    operation = gr.Radio(
        ["足し算", "引き算", "掛け算", "割り算"],
        label="演算",
        value="足し算"
    )
    result = gr.Textbox(label="計算結果")
    calculate_btn = gr.Button("計算")
    
    calculate_btn.click(
        calculate,
        inputs=[num1, num2, operation],
        outputs=result
    )

if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860)
