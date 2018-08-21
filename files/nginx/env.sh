export TEST_TRY_FILES='$uri $uri/ =404'
export X_ACS='https://$host$request_uri'


export HOST='$host'
export REQUEST_URI='$request_uri'

export NGXPORT80='80'
export NGXPORT8080='8080'
export NGXPORT9090='9090'
export LOCALPORT1='8686'
export LOCALPORT2='9696'
export LOCALHOST='127.0.0.1'
export NGXSERVERNAME='ddps.deic.dk'
export NGXSERVERALIAS='www.ddps.deic.dk'
export NGXROOT='/opt/ngx/ddosgui'
export NGXINDEX='index.html index.htm'
export TRY_FILES='$uri $uri/ /index.html?/$request_uri'

export SET='$auth $upstream_http_auth'
export AUTH='$auth'