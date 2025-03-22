import gradio as gr
import numpy as np
from PIL import Image

def sketch_to_image(sketch):
    # This is a simple demo function that just returns the input
    # In a real application, this could be a machine learning model
    return sketch

# Create a simple Gradio interface
demo = gr.Interface(
    fn=sketch_to_image,
    inputs=gr.Sketchpad(source="canvas", tool="pencil", height=400, width=400),
    outputs=gr.Image(),
    title="Sketch to Image",
    description="Draw a sketch and see it converted to an image.",
    examples=[["c:\\Prj\\eks-sandbox\\example\\gradio-app\\example_sketch.png"]],
    theme=gr.themes.Soft()
)

if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860)
