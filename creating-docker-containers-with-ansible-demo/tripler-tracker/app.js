var serverIp   = require('ip');
var express    = require('express');
var app        = express();
var router     = express.Router();
var bodyParser = require('body-parser');
var redis      = require('redis').createClient(6379, 'redis');
// var redis      = require("fakeredis").createClient(6379, 'redis');

var APP_VERSION = '0.0.4';
var HOST_IP     = serverIp.address();

console.log('host ip address: ' + HOST_IP);

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

router.get('/', function(req, res) {
  redis.incr(HOST_IP, function(err, hits) {
    if (err) {
      console.log(JSON.stringify(err, null, 2));
      res.send('something went wrong. check logs.');
    }

    console.log('number of host visits: ' + hits);
    res.setHeader('Content-Type', 'application/json')
    res.send(JSON.stringify({
      'host'    : HOST_IP,
      'hits'    : hits,
      'version' : APP_VERSION,
    }));

  });
});

app.use('/', router);
app.listen(8888, function() {
  console.log('app is listening on PORT 8888');
});
