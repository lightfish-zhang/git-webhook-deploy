## git webhook

http server for gitlab webhook, and some script for auto-deployment

## about shell deploy

- need to add you deploy server `.ssh/id_rsa.pub` to git server and add git server host finger point to `.ssh/known_hosts`
- the `util.sh` use `dingding robot message`, you can use other notify tool

## how to start

```
npm i
npm start
```

## suggestion

- use `pm2` as node processes manager