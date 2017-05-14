'use strict';

const callback = require('./callback');

exports.projects = [
  {
    name : 'repoName',
    callback : {
      develop: callback.example('projectName', 'ssh://git@xxx.com/xxx/repoName.git', 'develop'),
      master: callback.example('projectName', 'ssh://git@xxx.com/xxx/repoName.git', 'master'),
    }
  },
];

exports.server = {
  port : 7771,
  path : '/webhook',
  token : 'myToken'
};