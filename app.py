import gradio as gr
import os

# 加载环境变量
def load_env_variables():
    env_vars = {
        'AMAP_API_KEY': os.getenv('AMAP_API_KEY', ''),
        'DEEPSEEK_API_KEY': os.getenv('DEEPSEEK_API_KEY', ''),
        'DEEPSEEK_API_BASE_URL': os.getenv('DEEPSEEK_API_BASE_URL', ''),
        'VOICE_RECOGNITION_API_KEY': os.getenv('VOICE_RECOGNITION_API_KEY', ''),
        'VOICE_RECOGNITION_SECRET_KEY': os.getenv('VOICE_RECOGNITION_SECRET_KEY', ''),
        'VOICE_RECOGNITION_API_URL': os.getenv('VOICE_RECOGNITION_API_URL', ''),
        'WEATHER_API_BASE_URL': os.getenv('WEATHER_API_BASE_URL', ''),
        'WEATHER_API_KEY': os.getenv('WEATHER_API_KEY', ''),
        'WEATHER_CREDENTIAL_ID': os.getenv('WEATHER_CREDENTIAL_ID', ''),
        'GEOCODING_API_BASE_URL': os.getenv('GEOCODING_API_BASE_URL', ''),
        'NLP_API_URL': os.getenv('NLP_API_URL', ''),
        'NLP_API_KEY': os.getenv('NLP_API_KEY', ''),
    }
    return env_vars

def lifefit_ai(name):
    env_vars = load_env_variables()
    return f"Welcome to LifeFit AI, {name}! This is a schedule-driven intelligent fitness assistant."

demo = gr.Interface(
    fn=lifefit_ai,
    inputs="text",
    outputs="text",
    title="LifeFit AI",
    description="日程驱动的智能健身助手"
)

if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860)