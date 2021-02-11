# Build the app docker images

<!-- aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 975195398054.dkr.ecr.eu-west-1.amazonaws.com>
<!-- docker build -t 975195398054.dkr.ecr.eu-west-1.amazonaws.com/almanza:cn1v1 . -->

<!-- docker push 975195398054.dkr.ecr.eu-west-1.amazonaws.com/almanza:cn1v1 >

```
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin repo-url

docker build -t repo-url/almanza:cn1v1
docker build -t reponame/hire-almanza-cn1:v1 .
docker login
docker push reponame/hire-almanza-cn1:v1

```

```
docker build -t reponame/hire-almanza-cn2:v1 .

```