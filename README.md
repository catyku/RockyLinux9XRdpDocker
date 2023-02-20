# RockyLinux9XRdpDocker

### modify from https://github.com/danchitnis/container-xrdp centos8-xfce


### build docker image
```
docker build -t imagename . 
```

### run image
```
docker run -d --name containerName -p 3389:3389 imagename createUser password rootYesNo
```
like this

```
docker run -d --name rdp -p 3389:3389 rockylinuxrdp rocky rocky123 yes
```

### more information 
https://github.com/danchitnis/container-xrdp
