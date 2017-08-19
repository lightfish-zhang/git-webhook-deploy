
const cmd = require('./cmd');
const path = require('path');
const logger = require('./logger');

exports.shell = (shellName, ...param )=>{
  const shellPath = path.resolve(__dirname, `./shell/${shellName}.sh`);
  param.unshift(shellPath)
  return ()=>{
    logger.info(param);
    cmd('/bin/bash', param, function(text){ logger.info(text)});
  };
};