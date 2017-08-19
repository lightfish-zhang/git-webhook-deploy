'use strict';

const callback = require('./callback');

exports.projects = [
  {
    name : 'repoName',
    callback : {
      develop: callback.shell('shellName', 'projectName', 'ssh://xxx.com/xxx/repoName.git', 'develop'),
      master: callback.shell('shellName', 'projectName', 'ssh://xxx.com/xxx/repoName.git', 'develop'),
    }
  },
];

exports.server = {
  port : 7771,
  path : '/webhook',
  token : 'myToken'
};