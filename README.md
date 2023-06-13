# Containerized Coral Demo
This is a simple exmaple describing how to run the google coral tpu demo in a docker container. I built this for a few reasons, mainly because pycoral only works with python 3.9, and most modern OSs ship with 3.10 or 3.11, and also because I intend to experiment with tpu workloads on kubernetes.

I am using the m.2 and mini pcie modules. But this demo should work with the usb module as well. Feel free to mail me more modules if you want me to do more testing. :)

## Usage

Usage is simple. `docker compose up` will build and run the demo. You should see some output like this:

```
docker compose up
[+] Running 1/1
 ! tpucontainer Warning                                                                                          1.0s 
[+] Building 1.1s (10/10) FINISHED                                                                                    
 => [tpucontainer internal] load build definition from Dockerfile                                                0.3s
 => => transferring dockerfile: 692B                                                                             0.0s
 => [tpucontainer internal] load .dockerignore                                                                   0.3s
 => => transferring context: 2B                                                                                  0.0s
 => [tpucontainer internal] load metadata for docker.io/library/python:3.9-slim                                  0.7s
 => [tpucontainer 1/6] FROM docker.io/library/python:3.9-slim@sha256:5f0192a4f58a6ce99f732fe05e3b3d00f12ae62e18  0.0s
 => [tpucontainer 2/6] RUN apt-get update && apt-get install -y curl ca-certificates gnupg                       0.0s
 => [tpucontainer 3/6] RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" |          0.0s
 => [tpucontainer 4/6] WORKDIR /coral                                                                            0.0s
 => [tpucontainer 5/6] RUN git clone https://github.com/google-coral/pycoral.git .                               0.0s
 => [tpucontainer 6/6] RUN bash examples/install_requirements.sh classify_image.py                               0.0s
 => [tpucontainer] exporting to image                                                                            0.0s
 => => exporting layers                                                                                          0.0s
 => => writing image sha256:2e10fa5746473f7653fb9bbd92617e5c227e85a8c591c285ba7130b6c0cfb293                     0.0s
 => => naming to docker.io/library/coral                                                                         0.0s
[+] Running 1/1
 ✔ Container coral  Created                                                                                      0.4s 
Attaching to coral
coral  | /coral/examples/classify_image.py:79: DeprecationWarning: ANTIALIAS is deprecated and will be removed in Pillow 10 (2023-07-01). Use LANCZOS or Resampling.LANCZOS instead.
coral  |   image = Image.open(args.input).convert('RGB').resize(size, Image.ANTIALIAS)
coral  | ----INFERENCE TIME----
coral  | Note: The first inference on Edge TPU is slow because it includes loading the model into Edge TPU memory.
coral  | 12.0ms
coral  | 2.7ms
coral  | 2.6ms
coral  | 2.6ms
coral  | 2.6ms
coral  | -------RESULTS--------
coral  | Ara macao (Scarlet Macaw): 0.75781
coral exited with code 0
```

#### Note the deprecation warning. Seems like google is neglecting this code.

## Prerequisites
Ok.. so it's maybe not quite that simple. You need to first install some packages in the host system.

Follow the first few steps in the [Get started with the M.2 or Mini PCIe Accelerator](https://coral.ai/docs/m2/get-started/) document. I will copy the instructions below for completeness:

1. First, add our Debian package repository to your system (be sure you have an internet connection):
```
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update
```

2. Then install the PCIe driver and Edge TPU runtime packages:
```
sudo apt-get install gasket-dkms libedgetpu1-std
```

3. If the user account you'll be using does not have root permissions, you might need to also add the following udev rule, and then verify that the "apex" group exists and that your user is added to it:
```
sudo sh -c "echo 'SUBSYSTEM==\"apex\", MODE=\"0660\", GROUP=\"apex\"' >> /etc/udev/rules.d/65-apex.rules"

sudo groupadd apex

sudo adduser $USER apex
```

4. Reboot, and thats it.