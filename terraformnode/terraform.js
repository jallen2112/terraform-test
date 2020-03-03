const cp = require('child_process');
const process = require('process');
const fs = require('fs');
const { promisify } = require('util');
const rimraf = require('rimraf');

const readFileAsync = promisify(fs.readFile);

async function setupCwd(productName,fVars) {
  let productbackend;
  const cwd = `/tf_data/${productName}`;
  fs.mkdirSync(cwd, { recursive: true });
  productbackend = 'backend-local';
  fs.copyFileSync(`terragrunt-${productbackend}.hcl`, `${cwd}/terragrunt.hcl`);

  fs.writeFileSync(
    `${cwd}/terraform.tfvars`,
    Object.entries(tfVars).map(e => `${e[0]} = "${e[1]}"`).join('\n'),
  );

  return cwd;
}

function exec(command, options) {
  return new Promise(async (done, failed) => {
    const p = cp.exec(command, options);
    let lastError = '';
    let lastOut = '';
    p.stdout.on('data', (data) => {
      lastOut = data.toString();
      process.stdout.write(data);
    });
    p.stderr.on('data', (data) => {
      lastError = data.toString();
      process.stderr.write(data);
    });
    p.on('exit', (code) => {
      if (code === 0) {
        done(lastOut);
      } else {
        failed(new Error(lastError));
      }
    });
  });
}

module.exports = async (cmd, productName, tfVars) => {
  const cwd = await setupCwd(productName, tfVars);
  return exec(`terragrunt ${cmd}`, { cwd });
};
