## git webhook

用于git-webhook项目的自动更新服务器文件，这是gitlab版本，使用github可以将对代码小改动，修改package.json和index.js

## about shell deploy

- need to add you deploy server `.ssh/id_rsa.pub` to git server and add git server host finger point to `.ssh/known_hosts`
- the `example.sh` use `dingding robot message`, you can use other notify tool

## how to start

```
npm i
npm start
```

## suggestion

```
npm i forever -g
forever index.js
```