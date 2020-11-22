# gocheck
GitHub Action for golang code check

## For myself :3
```bash
docker build . -t gocheck
docker exec -it gocheck-test bash
docker run --workdir /workspace -v $PWD:/workspace gocheck ./golang
```
