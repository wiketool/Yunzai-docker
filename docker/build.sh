docker build . \
    --tag registry.cn-hangzhou.aliyuncs.com/<namespace>/trss-yunzai-bot:3.1.0\
    --build-arg BUNDLE_FFMPEG='false'\
    --build-arg BUNDLE_POETRY='false'\
    --build-arg USE_APT_MIRROR='false'\
    --build-arg USE_NPM_MIRROR='false'\
    --build-arg USE_PYPI_MIRROR='false'