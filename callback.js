
const cmd = require('./cmd');
const path = require('path');
const logger = require('./logger');

exports.example = (name, repo, branch)=>{
  return ()=>{
    const shellPath = path.resolve(__dirname, './shell/example.sh');
    cmd('/bin/bash', [shellPath ,name, repo, branch], function(text){ logger.info(text)});
  };
};

exports.yml_wechat_promotion_master = (name, repo, branch)=>{
  return ()=>{
    const shellPath = path.resolve(__dirname, './shell/yml_wechat_master.sh');
    cmd('/bin/bash', [shellPath ,name, repo, branch], function(text){ logger.info(text)});
  };
};