const run_cmd = (cmd, args, callback) => {
  let spawn = require('child_process').spawn;
  let child = spawn(cmd, args);
  let resp = "";
  
  child.stdout.on('data', function(buffer) { resp += buffer.toString(); });
  child.stdout.on('end', function() { callback (resp) });
};

module.exports = run_cmd;