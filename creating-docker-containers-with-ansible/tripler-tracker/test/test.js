var supertest = require('supertest');
var should = require('should');
var server = supertest.agent('http://localhost:8888');

describe("tripler tracker service is UP", function(){
  it("should return a 200 status code",function(done){
    server
    .get("/")
    .expect("Content-type",/json/)
    .expect(200)
    .end(function(err, res){
      res.status.should.equal(200);
      done();
    });
  });

  it("should return number of hits",function(done){
    server
    .get("/")
    .expect("Content-type",/json/)
    .expect(200)
    .end(function(err, res){
      res.body.hits.should.be.a.Number;
      done();
    });
  });

  it("should return the app version number",function(done){
    server
    .get("/")
    .expect("Content-type",/json/)
    .expect(200)
    .end(function(err, res){
      res.body.version.should.equal('0.0.4')
      done();
    });
  });
});
