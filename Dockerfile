FROM modelscope-registry.cn-beijing.cr.aliyuncs.com/modelscope-repo/python:3.10

WORKDIR /home/user/app

COPY ./build/web /home/user/app

# 使用Python的http.server来提供静态文件，不需要额外安装库
EXPOSE 7860
CMD ["python", "-m", "http.server", "7860"]