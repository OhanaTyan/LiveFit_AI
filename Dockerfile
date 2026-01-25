FROM python:3.10-slim

WORKDIR /app

COPY ./build/web /app

EXPOSE 7860

# 使用Python内置的http.server提供静态文件服务
CMD python -m http.server 7860