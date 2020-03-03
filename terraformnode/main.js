const terraform = require('./terraform.js');

async function main () {
  console.log("hello-world")
  var terraformRepo = `github.com/jallen2112/terraform-test//s3-example`
  var product = 'fake-product-2'

  output = await terraform(
    `apply --terragrunt-source ${terraformRepo}?ref=s3-mapobject`,
    product,           
    {                      
      projects: createMap(),
    },                     
  );                       
  console.log("goodbye-world")
  
}


function createMap() {
  map = new Map();
  var object = {name: 'takumi-serge34t3t452', access: 'public'}
  map.set('takumi', object)
  var object2 = {name: 'jordan-argaerg234', access: 'private'}
  map.set('jordan', object2)
  console.log(JSON.stringify(Object.fromEntries(map)));
  return JSON.stringify(Object.fromEntries(map))
}

main()
