var serverIp = require('ip');
var express  = require('express');
var app      = express();
var redis    = require('redis').createClient(6379, 'redis');

var APP_VERSION = '0.0.4';
var HOST_IP     = serverIp.address();

console.log('host ip address: ' + HOST_IP);

app.get('/', function(req, res) {
  redis.incr(HOST_IP, function(err, hits) {
    if (err) {
      console.log(JSON.stringify(err, null, 2));
      res.send('something went wrong. check logs.');
    }

    console.log('number of host visits: ' + hits);

    res.send(JSON.stringify({
      'host ip'     : HOST_IP,
      'host hits'   : hits,
      'app version' : APP_VERSION,
    }));

  });
});

app.listen(80);
