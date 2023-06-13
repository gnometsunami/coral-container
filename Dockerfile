FROM python:3.9-slim

RUN apt-get update && apt-get install -y curl ca-certificates gnupg

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  apt-get update && apt-get upgrade -y && apt-get install -y python3-pycoral gasket-dkms libedgetpu1-std git && \
  python3 -m pip install --extra-index-url https://google-coral.github.io/py-repo/ pycoral~=2.0

WORKDIR /coral

RUN git clone https://github.com/google-coral/pycoral.git .
RUN bash examples/install_requirements.sh classify_image.py
