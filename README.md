# httphost.dev

## Bootstrap your Amazon Web Services account

Before you can deploy any hosting infrastructure to your Amazon Web Services account, you must bootstrap it.

As a powerful user, manually:

1. Deploy [cloudformation/bootstrap.cf.yaml](cloudformation/bootstrap.cf.yaml) with the stack name `httphostdev-bootstrap`.
1. Attach the Managed Policy `httphost.dev-ManageWebsiteInfrastructure-{REGION}` to roles and users that need to deploy hosting infrastructure.

## Deploying a new website

### Preparing the infrastructure

As any role or user with permission to manage website infrastructure, run:

```bash
./bootstrap-website.sh <DOMAIN>
```

For example:

```bash
./bootstrap-website.sh example.com
```

The script will print a list of name servers which you must apply to the domain in your registrar. The script cannot do this for you.

TODO

### Publishing content

TODO
