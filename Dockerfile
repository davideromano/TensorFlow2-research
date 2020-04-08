FROM tensorflow/tensorflow:2.0.0-gpu-py3-jupyter

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="python3.6-ubuntu18.04:tensorflow2.0.0-gpu-jupyter-01"
LABEL maintainer="Davide"

ENV TZ=Europe/Rome

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    tzdata \
    ca-certificates \
    python3-pip \
    curl \
    git \
 && update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1 \
 && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 \
 # Cleaning after installations
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# See https://github.com/ipython-contrib/jupyter_contrib_nbextensions
RUN pip install jupyter_contrib_nbextensions \
 && jupyter contrib nbextension install

ADD .jupyter /.jupyter

COPY requirements.txt ./
RUN pip install -r requirements.txt
RUN rm -f requirements.txt

RUN mkdir /tf/tb_logs \
 && chmod 777 /tf/tb_logs

CMD [ "bash", "-c", "tensorboard --logdir=/tf/tb_logs --bind_all & source /etc/bash.bashrc && jupyter notebook --config=/.jupyter/jupyter_notebook_config.py"]

#docker build -t covid-19-kaggle-jupyter-notebook -f Dockerfile.jupyter-notebook --no-cache .

#docker run --rm -d \
#-p 9000:8888 \
#-p 9006:6006 \
#--runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 \
#--user root \
#-e GRANT_SUDO=yes \
#-v $(pwd):/tf \
#--name covid-19-jupyter-notebook \
#covid-19-kaggle-jupyter-notebook
