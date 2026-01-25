FROM modelscope-registry.cn-beijing.cr.aliyuncs.com/modelscope-repo/python:3.10

WORKDIR /home/user/app

COPY ./build/web /home/user/app

RUN pip install -r requirements.txt

# 使用Python的http.server来提供静态文件
EXPOSE 7860
CMD ["python", "-m", "http.server", "7860"]