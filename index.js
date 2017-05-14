'use strict';

const config = require('./config');
const http = require('http')
const createHandler = require('gitlab-webhook-handler')
const logger = require('./logger')
const handler = createHandler({ path: config.server.path})
const port = config.server.port;
const projectMap = new Map();

config.projects.forEach((project)=>{
  projectMap.set(project.name, project);
});



http.createServer(function (req, res) {
  
  const reqToken = req.headers['x-gitlab-token'];
  logger.info(reqToken);
  if(reqToken !== config.server.token){
    res.writeHead(400)
    res.end('invalid token')
    return;
  }
  
  handler(req, res, function (err) {
    res.statusCode = 404
    res.end('no such location')
  })
}).listen(port)

logger.info("Gitlab Hook Server running at http://0.0.0.0:"+port);


handler.on('error', function (err) {
  console.error('Error:', err.message)
})

handler.on('push', function (event) {
  let name = event.payload.repository.name;
  let ref = event.payload.ref;
  logger.info('Received a push event for %s to %s',
              name,
              ref);
  if(projectMap.has(name)){
    let project = projectMap.get(name);
    let branch = ref.split('/').pop();
    logger.info('project %s branch %s', name, branch);
    if(branch === 'develop'){
      project.callback.develop();
    }else if(branch === 'master'){
      project.callback.master();
    }
  }
})

// handler.on('merge', function (event) {
//   let name = event.payload.repository.name;
//   let ref = event.payload.ref;
//   logger.info('merge a merge event for %s to %s',
//               name,
//               ref);
//   logger.info(JSON.stringify(event));
//   if(projectMap.has(name)){
//     let project = projectMap.get(name);
//     let branch = ref.split('/').pop();
//     if(branch === 'develop'){
//       project.callback.develop();
//     }else if(branch === 'master'){
//       project.callback.master();
//     }
//   }
// })


handler.on('issues', function (event) {
  logger.info('Received an issue event for %s action=%s: #%d %s',
              event.payload.repository.name,
              event.payload.action,
              event.payload.issue.number,
              event.payload.issue.title)
})