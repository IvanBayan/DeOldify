#!/bin/bash
if [[ ! -f /data/models/vgg16_bn-6c64b313.pth ]] 
then
		wget -O /root/.torch/models/vgg16_bn-6c64b313.pth https://download.pytorch.org/models/vgg16_bn-6c64b313.pth
fi
if [[ ! -f /data/models/resnet34-333f7ec4.pth ]]
then
       	wget -O /root/.torch/models/resnet34-333f7ec4.pth https://download.pytorch.org/models/resnet34-333f7ec4.pth
fi
if [[ ! -f /data/models/ColorizeArtistic_gen.pth ]] 
then
	wget -O /data/models/ColorizeArtistic_gen.pth https://data.deepai.org/deoldify/ColorizeArtistic_gen.pth
fi
if [[ ! -f /data/models/ColorizeVideo_gen.pth ]]
then
	wget -O /data/models/ColorizeVideo_gen.pth https://data.deepai.org/deoldify/ColorizeVideo_gen.pth
fi

