# apigtw-sqs-integration
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

This project is a basic sample of api gateway integration with a SQS queue and a lambda consumer.

## Architecture

Below is an architectural drawing with resource communications.

![architecture](./docs/apigtw-sqs-integration.jpeg)

## Requirements
- Terraform v0.13.5
- Your aws credentials configured
- A s3 bucket for your tf.state file

## Applying your resources

First, make sure you have your credentials file configured with your AWS account in your local machine.

```editorconfig
[default]
aws_access_key_id = YOUR-ACCESS-KEY-ID
aws_secret_access_key = YOU-SECRET-ACCESS-KEY
```

Create a bucket in s3 and change your main.tf with your bucket name.

```terraform
terraform {
  backend "s3" {
    bucket = "my-bucket-name"
    key    = "tf-state/terraform.tfstate"
    region = "us-east-1"
  }
}
```

Initialize Terraform.

```bash
$ terraform init
```

Make a plan in the project root directory. *(optional)*

```bash
$ terraform plan
```

Run apply to create all the resources.

```bash
$ terraform apply
```

After applying, the output shows the API gateway endpoints resources.

```bash
Outputs:

apigateway_resource_one = https://id.execute-api.us-east-1.amazonaws.com/dev/one
apigateway_resource_two = https://id.execute-api.us-east-1.amazonaws.com/dev/two
```

## Invoking API
To invoke your api gateway and test your infrastructure, import the **collection** and **environment** from the **docs** folder and set your api gateway id generated from apply.

## Destroy

To destroy all your infrastructure, just run terraform destroy.

```bash
$ terraform destroy
```

## Documentations

- https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html
- https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-method-request-validation.html
- https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-integration-settings.html

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/leomenezessz/"><img src="https://avatars.githubusercontent.com/u/35569098?v=4?s=100" width="100px;" alt="Leonardo Menezes"/><br /><sub><b>Leonardo Menezes</b></sub></a><br /><a href="https://github.com/leomenezessz/apigtw-sqs-integration/commits?author=leomenezessz" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!