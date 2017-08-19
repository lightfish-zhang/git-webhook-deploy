robotMsg(){
    curl 'https://oapi.dingtalk.com/robot/send?access_token=xxx' \
    -H 'Content-Type: application/json' \
    -d "
    {\"msgtype\": \"text\",
    \"text\": {
        \"content\" : \"${1}\"
     }
    }"
}