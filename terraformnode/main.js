const terraform = require('./terraform.js');

async function main () {
  console.log("hello-world")
  var terraformRepo = `github.com/jallen2112/terraform-test//s3-example`
  var product = 'fake-product'

  output = await terraform(
    `apply --terragrunt-source ${terraformRepo}?ref=s3-mapobject`,
    product,           
    {                      
      name: "sergsergrstgsrte-3453635",
      access: "public",
    },                     
  );                       
  console.log("goodbye-world")
  
}

main()
