FROM nvcr.io/nvidia/pytorch:22.06-py3

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN     echo -e "tzdata tzdata/Areas select Europe\n\
                 tzdata tzdata/Zones/Europe select Berlin\n\
                 locales locales/locales_to_be_generated multiselect     en_US.UTF-8 UTF-8\n\
		 locales locales/default_environment_locale      select  en_US.UTF-8\n" > /tmp/preseed.cfg && \
	debconf-set-selections /tmp/preseed.cfg && \
        apt-get -y update && \
	apt-get -y install tzdata && \
        apt-get install -y python3-pip software-properties-common wget \
	ca-certificates libcurl4-openssl-dev libssl-dev ffmpeg && \
	apt-get clean && \
	update-ca-certificates -f && \
	mkdir -p /root/.torch/ /data/models && \
#	mkdir -p /root/.torch/models /data/models && \
	ln -sf /data/models /root/.torch/




# if you want to avoid image building with downloading put your .pth file in root folder
#COPY Dockerfile ColorizeArtistic_gen.* /data/models/
#COPY Dockerfile ColorizeVideo_gen.* /data/models/
COPY *.pth models/*.pth /data/models/

ADD . /data/
RUN pip install -r /data/requirements.txt



WORKDIR /data

# force download of file if not provided by local cache
#RUN [ ! -f /data/models/vgg16_bn-6c64b313.pth ] &&  wget -O /root/.torch/models/vgg16_bn-6c64b313.pth https://download.pytorch.org/models/vgg16_bn-6c64b313.pth
#RUN [ ! -f /data/models/resnet34-333f7ec4.pth ] && wget -O /root/.torch/models/resnet34-333f7ec4.pth https://download.pytorch.org/models/resnet34-333f7ec4.pth
#RUN [ ! -f /data/models/ColorizeArtistic_gen.pth ] && wget -O /data/models/ColorizeArtistic_gen.pth https://data.deepai.org/deoldify/ColorizeArtistic_gen.pth
#RUN [ ! -f /data/models/ColorizeVideo_gen.pth ] && wget -O /data/models/ColorizeVideo_gen.pth https://data.deepai.org/deoldify/ColorizeVideo_gen.pth
RUN /data/get_models.sh

COPY run_notebook.sh /usr/local/bin/run_notebook
COPY run_image_api.sh /usr/local/bin/run_image_api
COPY run_video_api.sh /usr/local/bin/run_video_api

RUN chmod +x /usr/local/bin/run_notebook
RUN chmod +x /usr/local/bin/run_image_api
RUN chmod +x /usr/local/bin/run_video_api

EXPOSE 8888
EXPOSE 5000

# run notebook
# ENTRYPOINT ["sh", "run_notebook"]

# run image api
ENTRYPOINT ["sh", "run_image_api"]

# run image api
# ENTRYPOINT ["sh", "run_video_api"]
