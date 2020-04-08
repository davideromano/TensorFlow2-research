# TensorFlow 2 research

```bash
docker build -t --no-cache .
```

```bash
docker run \
    --rm -d \
    -p 9000:8888 \
    -p 9006:6006 \
    --runtime=nvidia \
    -e NVIDIA_VISIBLE_DEVICES=0 \
    --user root \
    -e GRANT_SUDO=yes \
    -v $(pwd):/tf \
    --name tf2-research \
    tf2-research
```